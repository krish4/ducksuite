class UpdateInboxNotifications

  def initialize(album_id, redis_db)
    @album_id = album_id
    @redis_db = redis_db
  end

  def call
    if unseen_pictures_number > 0
      if n = get_current_day_notification
        notification[:unseen_pictures_number] += n["unseen_pictures_number"]
        redis_db.remove_from_set(cache_name, n)
      end
      redis_db.add_to_set(cache_name, notification)
    end
  end

  private
  attr_reader :album_id, :redis_db

  def cache_name
    CacheName.inbox_notifications(album_id)
  end

  def get_current_day_notification
    notifications = RetrieveInboxNotifications.new(album_id, redis_db).call
    notifications.detect { |n| n["created_at"].to_date == current_date }
  end 

  def notification
    { 
      created_at: Time.now,
      unseen_pictures_number: unseen_pictures_number
    }
  end

  def unseen_pictures_number
    @unseen_pictures_number ||= CountInboxPictures.new(redis_db, album_id, count_only_unseen = true).call
  end

  def current_date
    @current_date ||= Date.today
  end
end