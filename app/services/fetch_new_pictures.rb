class FetchNewPictures
  
  def initialize(current_user, album)
    @album = album
    @current_user = current_user
  end

  def call
    result = { pictures: [] }
    current_request = 0
    begin
      loop do
        data = FetchPictures.new(@current_user, @album, last_fetched_max_id, current_min_id).call
        result[:pictures] += data[:pictures]
        next_max_id = data[:next_max_id]
        next_min_id = data[:next_min_id]
        options = { last_fetched_min_id: next_min_id }
        options[:current_min_id] = current_min_id = next_min_id unless current_min_id.present?
        any_more_pictures = next_max_id > current_min_id rescue false
        if any_more_pictures
          options[:last_fetched_max_id] = next_max_id
        else
          options[:last_fetched_max_id] = nil
          options[:current_min_id] = next_min_id
        end
        update_inbox_info(options)
        current_request += 1
        break unless any_more_pictures && current_request < requests_limit
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

  def last_fetched_max_id 
    inbox_info["last_fetched_max_id"]
  end

  def requests_limit
    @requests_limit = AppConfig.max_consecutive_requests
  end
end
