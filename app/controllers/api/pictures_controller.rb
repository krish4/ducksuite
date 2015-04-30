class API::PicturesController < API::BaseController
  protect_from_forgery with: :null_session
  before_action :set_album, only: [:index, :show, :accept, :accept_all, :deny, :deny_all, :destroy, :fetch_old_instagram_pictures, :fetch_new_instagram_pictures, :inbox_pictures]
  before_action :set_picture, only: [:accept, :deny, :destroy]

  # Returns pictures from album
  def index
    cached_pictures = get_cached_album_pictures(@album.id)
    render json: cached_pictures
  end

  # Returns pictures from Instagram
  def fetch_old_instagram_pictures
    data = FetchOldPictures.new(current_user, @album).call
    data[:pictures] = CachePictures.new(data[:pictures], @album.id, redis_client).call
    Inbox.new(@album.id).visited!
    render json: data
  end

  # Returns the most recent – only new – pictures from Instagram
  def fetch_new_instagram_pictures
    data = FetchNewPictures.new(current_user, @album).call
    data[:pictures] = CachePictures.new(data[:pictures], @album.id, redis_client, true).call
    Inbox.new(@album.id).visited!
    render json: data
  end

  def inbox_pictures
    cached_pictures = get_cached_inbox_pictures(@album.id)
    Inbox.new(@album.id).visited!
    RemoveInboxNotifications.new(@album.id, redis_client).call
    render json: cached_pictures
  end

  def show
    picture = @album.pictures.where(instagram_id: params[:id]).first
    render json: picture
  end

  # It sets picture's status as :accepted
  def accept
    @picture.accept
    cached_picture = get_cached_inbox_picture(params[:id])
    set_picture_as_accepted(cached_picture, @album.id)
    render json: cached_picture
  end

  def accept_all
    get_cached_inbox_pictures(@album.id).each do |picture|
      saved_pic = Picture.find_or_create_by(instagram_id: picture["id"], album_id: @album.id)
      next if saved_pic.denied?
      saved_pic.accept
      cached_picture = get_cached_inbox_picture(picture["id"])
      set_picture_as_accepted(cached_picture, @album.id)
    end
    head :no_content
  end

  # It sets picture's status as :denied
  def deny
    @picture.deny
    cached_picture = get_cached_inbox_picture(params[:id])
    set_picture_as_denied(cached_picture, @album.id)
    render json: cached_picture
  end

  def deny_all
    get_cached_inbox_pictures(@album.id).each do |picture|
      saved_pic = Picture.find_or_create_by(instagram_id: picture["id"], album_id: @album.id)
      next if saved_pic.accepted?
      saved_pic.deny
      cached_picture = get_cached_inbox_picture(picture["id"])
      set_picture_as_denied(cached_picture, @album.id)
    end
    head :no_content
  end

  def destroy
    @picture.destroy
    cached_picture = get_cached_album_picture(params[:id])
    if cached_picture.present?
      RemoveAcceptedFromCache.new(cached_picture, @album.id, redis_client).call
    end
    head :no_content
  end

  private
    def set_album
      @album = Album.find(params[:album_id])
    end

    def set_picture
      @picture = Picture.find_or_create_by(instagram_id: params[:id], album_id: params[:album_id])
    end

    def set_picture_as_accepted(cached_picture, album_id)
      return unless cached_picture.present?
      RemoveFromCache.new(cached_picture, album_id, redis_client).call
      CacheAcceptedPicture.new(cached_picture, album_id, redis_client).call
    end

    def set_picture_as_denied(cached_picture, album_id)
      return unless cached_picture.present?
      RemoveFromCache.new(cached_picture, album_id, redis_client).call
      CacheDeniedPicture.new(cached_picture, album_id, redis_client).call
    end

    def get_cached_inbox_picture(id)
      old_pics = CacheName.old_album_name(@album.id)
      new_pics = CacheName.new_album_name(@album.id)
      picture = find_picture_in_album(id, old_pics) || find_picture_in_album(id, new_pics)
      picture.present? ? JSON.parse(picture) : nil
    end

    def get_cached_inbox_pictures(album_id)
      RetrievePicturesFromCache.new(CacheName.old_album_name(album_id), redis_client).call + 
      RetrievePicturesFromCache.new(CacheName.new_album_name(album_id), redis_client).call
    end

    def get_cached_album_picture(id)
      picture = find_picture_in_album(id, CacheName.accepted_album_name(@album.id))
      picture.present? ? JSON.parse(picture) : nil
    end

    def get_cached_album_pictures(album_id)
      RetrievePicturesFromCache.new(CacheName.accepted_album_name(album_id), redis_client).call
    end

    def find_picture_in_album(picture_id, album_name)
      redis_client.find_picture_in_set(album_name, picture_id)
    end
end
