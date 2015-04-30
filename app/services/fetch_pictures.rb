class FetchPictures
  
  def initialize(current_user, album, max_id = nil, min_id = nil)
    @max_id = max_id
    @min_id = min_id
    @album = album
    @instagram = InstagramProvider.new(current_user)
  end

  def call
    result = {}
    begin
      data = @instagram.get_pictures_by_hashtag(@album.main_hashtag, @max_id, @min_id)
      result[:pictures] = filter_pictures(data)
    rescue Instagram::TooManyRequests
      result[:requests_limit_reached] = true
      logger.error  "Fetching pictures with the following hashtag: '#{main_hashtag}' has been stopped! " +
                    "(Instagram: The maximum number of requests per hour has been exceeded.)"
    end
    result[:next_max_id] = next_max_id(data)
    result[:next_min_id] = next_min_id(data)
    result
  end

  private
  def filter_pictures(pictures)
    pictures.map do |picture|
      next unless @album.satisfy_most_album_settings?(picture)
      picture[:followers_number] = @instagram.get_user_followers_number(picture.user.id)
      picture if @album.matches_followers_number?(picture)
    end.reject(&:blank?)
  end

  def next_max_id(data)
    data.pagination.max_tag_id || data.pagination.next_max_id || data.pagination.next_max_tag_id
  end

  def next_min_id(data)
    data.pagination.min_tag_id || data.pagination.next_min_id || data.pagination.next_min_tag_id
  end
  
end