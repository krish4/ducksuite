class RetrieveInboxNotifications

  def initialize(album_id, redis_db)
    @album_id = album_id
    @redis_db = redis_db
  end

  def call
    redis_db.get_members(cache_name).map do |notification|
      JSON.parse(notification)
    end
  end

  private 
  attr_reader :album_id, :redis_db

  def cache_name
    CacheName.inbox_notifications(album_id)
  end
end
