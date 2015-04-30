class FetchOldPictures
  
  def initialize(current_user, album)
    @album = album
    @current_user = current_user
  end

  def call
    result = { pictures: [], older_pictures_exist: older_pictures_exist? }
    return unless older_pictures_exist?
    current_request = 0
    begin
      loop do
        data = FetchPictures.new(@current_user, @album, current_max_id).call
        result[:pictures] += data[:pictures]
        older_pictures_exist = data[:next_max_id].present?
        options = { look_for_older_pictures: older_pictures_exist }
        result[:older_pictures_exist] = older_pictures_exist
        options[:current_max_id] = data[:next_max_id] if older_pictures_exist
        update_inbox_info(options)
        current_request += 1
        break unless older_pictures_exist && current_request < requests_limit
      end
    rescue Instagram::TooManyRequests
      result[:requests_limit_reached] = true
      logger.error  "Fetching pictures with the following hashtag: '#{main_hashtag}' has been stopped! " +
                    "(Instagram: The maximum number of requests per hour has been exceeded.)"
    end
    result
  end

  private
  def inbox_info
    @inbox_info ||= begin
      inbox = REDIS.get("inbox_#{@album.id}")
      if inbox.nil?
        Inbox.new(@album.id).save
        inbox = REDIS.get("inbox_#{@album.id}")
      end      
      JSON.parse(inbox)
    end
  end

  def update_inbox_info(options)
    Inbox.new(@album.id).update(options)
  end
  
  def current_min_id
    inbox_info["current_min_id"]
  end

  def current_max_id 
    inbox_info["current_max_id"]
  end

  def older_pictures_exist?
    @older_pictures_exist ||= inbox_info["look_for_older_pictures"]
  end

  def requests_limit
    @requests_limit = AppConfig.max_consecutive_requests
  end
end