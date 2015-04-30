class RetrieveUserAlbumsFromCache
  def initialize(user_id, redisDb)
    @user_id = user_id
    @redisDb = redisDb
  end

  def call
    redisDb.get_members(cached_albums_name).map do |album|
      JSON.parse(album)
    end
  end

  private
  attr_reader :user_id, :redisDb

  def cached_albums_name
    CacheName.user_albums_name(user_id)
  end
end
