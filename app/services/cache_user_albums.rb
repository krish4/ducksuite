class CacheUserAlbums
  def initialize(user_id, redis_db)
    @user_id = user_id
    @redis_db = redis_db
    @cached_albums = []
  end

  def call
    user_albums.each do |album|
      cache_album(album) if get_cached_album(album).nil?
    end
    @cached_albums
  end

  private
  attr_reader :redis_db

  def cached_albums_name
    CacheName.user_albums_name(@user_id)
  end

  def user_albums
    User.find_or_initialize_by(id: @user_id).albums
  end

  def get_cached_album(album)
    redis_db.get_cached_album(album.id, cached_albums_name)
  end

  def cache_album(album)
    serialized_album = album_data(album)
    redis_db.cache_album(serialized_album, cached_albums_name)
    @cached_albums << serialized_album
  end

  def album_data(album)
    AlbumSerializer.new(album).as_json(root: false)
  end
end