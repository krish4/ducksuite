class RedisClient
  def initialize
    @redis = REDIS
  end

  def add_to_set(store_name, resource)
    redis.sadd store_name, resource.to_json
  end

  def find_picture_in_set(store_name, picture_id)
    redis.sscan_each(store_name, {match: "*#{picture_id}*"}).first
  end

  def cache_album(album, store_name)
    redis.sadd store_name, album.to_json
  end

  def get_cached_album(album_id, store_name)
    redis.sscan_each(store_name, {match: "*\"id\":#{album_id}*"}).first
  end

  def remove_from_set(store_name, resource)
    redis.srem store_name, resource.to_json
  end

  def remove_all_from_set(store_name)
    redis.del store_name
  end

  def random_members(store_name, count)
    redis.srandmember(store_name, count)
  end

  def get_members(store_name)
    redis.smembers store_name
  end

  def get_members_count(store_name)
    redis.scard store_name
  end

  private
  attr_reader :redis
end
