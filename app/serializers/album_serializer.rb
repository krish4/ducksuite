class AlbumSerializer < ActiveModel::Serializer
  attributes  :id, :title, :is_published, :min_followers_number, :min_comments_number, :min_likes_number, :hashtags,
              :pictures_number, :sample_pictures, :recent_pictures, :notifications, :inbox_count, :location, :last_visited_inbox_at, :user_id

  def sample_pictures
    sample_pictures = []
    get_random_members.map do |pic|
      picture = JSON.parse(pic)
      sample_pictures << picture['images']['standard_resolution']['url']
    end
    sample_pictures
  end

  def inbox_count
    CountInboxPictures.new(redis, self.id, true).call
  end

  def last_visited_inbox_at
    inbox = REDIS.get CacheName.inbox_album_name(self.id)
    JSON.parse(inbox)["last_visited_at"] if inbox.present?
  end

  def recent_pictures
    redis.random_members(CacheName.new_album_name(self.id), 5).map do |picture|
      JSON.parse(picture)
    end
  end

  def notifications
    RetrieveInboxNotifications.new(self.id, redis).call
  end

  private

  def get_random_members
    album_name = CacheName.accepted_album_name(self.id)
    redis.random_members(album_name, 10)
  end

  def redis
    RedisClient.new
  end
end
