class RemoveUserAlbumFromCache
  def initialize(user_id, album_id, redis_db)
    @user_id = user_id
    @album_id = album_id
    @redis_db = redis_db
  end

  def call
    redis_db.remove_from_set(cached_albums_name, cached_album)
  end

  private
  attr_reader :user_id, :album_id, :redis_db

  def cached_albums_name
    CacheName.user_albums_name(user_id)
  end

  def cached_album
    album = redis_db.get_cached_album(album_id, cached_albums_name)
    JSON.parse(album) if album.present?
  end
end