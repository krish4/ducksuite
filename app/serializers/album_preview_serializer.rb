class AlbumPreviewSerializer < ActiveModel::Serializer
  attributes  :id, :title, :is_published, :min_followers_number, :min_comments_number, :min_likes_number, :hashtags,
              :location, :recent_pictures, :notifications, :last_visited_inbox_at, :new_pictures_number

  def recent_pictures
    redis.random_members(CacheName.new_album_name(self.id), 5).map do |picture|
      JSON.parse(picture)
    end
  end

  def last_visited_inbox_at
    inbox = REDIS.get CacheName.inbox_album_name(self.id)
    JSON.parse(inbox)["last_visited_at"] if inbox.present?
  end

  def new_pictures_number 
    CountInboxPictures.new(redis, self.id, count_only_new = true).call
  end

  def notifications
    RetrieveInboxNotifications.new(self.id, redis).call
  end

  private
  
  def redis
    RedisClient.new
  end
end
