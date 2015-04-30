class API::AlbumsController < API::BaseController
  protect_from_forgery with: :null_session
  before_action :set_album, only: [:show, :update, :destroy]

  def index
    #CacheUserAlbums.new(current_user.id, redis_client).call
    #albums = RetrieveUserAlbumsFromCache.new(current_user.id, redis_client).call
    render json: current_user.albums, status: :ok
  end

  def show
    render json: @album, serializer: AlbumPreviewSerializer, status: :ok
  end

  def create
    album = Album.new(album_params)

    if album.save!
      render json: album, status: :created
    else
      render json: album.errors, status: :unprocessable_entity
    end
  end

  def update
    location_params = album_params[:location_attributes]

    updated = if location_params.present? && location_params[:name].blank?
      @album.update(album_params.except(:location_attributes)) 
      @album.location.destroy if @album.location.present?
    else
      @album.update(album_params)
    end

    if updated
      head :no_content
    else
      render json: @album.errors, status: :unprocessable_entity
    end
  end

  def destroy
    RemoveUserAlbumFromCache.new(@album.user.id, @album.id, redis_client).call
    @album.destroy
    head :no_content
  end

  private
    def set_album
      @album = Album.find(params[:id])
    end

    def album_params
      params.require(:album).permit(:id, :is_published, :title, :min_followers_number, :min_comments_number, 
        :min_likes_number, :user_id, hashtags: [], location_attributes: [:name, :latitude, :longitude, :radius])
    end
end
