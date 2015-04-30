class CacheDeniedPicture
  def initialize(picture, album_id, redis_db)
    @picture = picture
    @album_id = album_id
    @redis_db = redis_db
  end

  def call
    redis_db.add_to_set(store_name, picture)
  end

  private
  attr_reader :picture, :redis_db, :album_id

  def store_name
    CacheName.denied_pictures_store(album_id)
  end
end