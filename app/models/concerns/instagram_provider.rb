class InstagramProvider
  
  def initialize(user)
    @user = user
    set_client
  end

  def get_access_token
    if @user.present? && @user.is_authenticated(:instagram)
      @user.get_access_token(:instagram)
    else 
      ENV["INSTAGRAM_ACCESS_TOKEN"]
    end
  end

  def get_requests_limit_number
    begin
      @client.utils_raw_response.headers[:x_ratelimit_limit].to_i
    rescue Instagram::TooManyRequests
      5000
    end
  end

  def get_remaining_requests_number
    begin
      @client.utils_raw_response.headers[:x_ratelimit_remaining].to_i
    rescue Instagram::TooManyRequests
      0
    end
  end

  def requests_limit_reached
    begin
      get_remaining_requests_number <= 0
    rescue Instagram::TooManyRequests
      true
    end
  end

  def get_picture(picture_id)
    @client.media_item(picture_id) 
  end

  def get_picture_with_followers_number(picture_id)
    picture = get_picture(picture_id)
    picture.followers_number = get_user_followers_number(picture.user.id)
    picture
  end

  def get_picture_url(picture_id)
    get_picture(picture_id).images.low_resolution.url
  end

  def get_picture_comments(picture_id)
    @client.media_comments(picture_id)
  end

  def get_user(user_id)
    @client.user(user_id)
  end

  def get_user_followers_number(user_id)
    user = get_user(user_id)
    user.counts.followed_by
  end

  def get_number_of_pictures_with_hashtag(hashtag)
    escaped_hashtag = escape_hashtag(hashtag)
    @client.tag(escaped_hashtag).media_count
  end

  def get_main_hashtag(hashtags)
    pictures_number = {}
    if hashtags.count > 1
      hashtags.each { |tag| pictures_number[tag] = get_number_of_pictures_with_hashtag(tag) }
      Hash[pictures_number.sort_by{ |hashtag, pictures_number| pictures_number }].keys.first
    else
      hashtags.first
    end
  end

  def get_pictures_by_hashtag(hashtag, max_id = nil, min_id = nil, count = AppConfig["max_pictures_per_request"])
    escaped_hashtag = escape_hashtag(hashtag)
    @client.tag_recent_media(escaped_hashtag, max_id: max_id, min_id: min_id, count: count)
  end

  private
    def set_client
      @client ||= Instagram.client(access_token: get_access_token)
    end

    def escape_hashtag(hashtag)
      URI::escape(hashtag)
    end

end
