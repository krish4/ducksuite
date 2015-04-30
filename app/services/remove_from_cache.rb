class RemoveFromCache
  def initialize(picture, album_id, redis_db)
    @picture = picture
    @album_id = album_id
    @redis_db = redis_db
  end

  def call
    redis_db.remove_from_set(old_album_name, picture)
    redis_db.remove_from_set(new_album_name, picture)
  end

  private
  attr_reader :picture, :album_id, :redis_db

  def old_album_name
    CacheName.old_album_name(album_id)
  end

  def new_album_name
    CacheName.new_album_name(album_id)
  end
end
