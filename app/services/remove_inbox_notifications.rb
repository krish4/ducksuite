class RemoveInboxNotifications

  def initialize(album_id, redis_db)
    @album_id = album_id
    @redis_db = redis_db
  end

  def call
    redis_db.remove_all_from_set(cache_name)
  end

  private
  attr_reader :album_id, :redis_db

  def cache_name
    CacheName.inbox_notifications(album_id)
  end

end