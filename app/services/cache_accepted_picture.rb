class CacheAcceptedPicture
  def initialize(picture, album_id, redis_db)
    @picture = picture
    @album_id = album_id
    @redis_db = redis_db
  end

  def call
    redis_db.add_to_set(store_name, picture)
  end

  private
  attr_reader :redis_db, :picture, :album_id

  def store_name
    CacheName.accepted_album_name(album_id)
  end
end
