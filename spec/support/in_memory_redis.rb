# In-memory REDIS implementation
# Compare with app/models/redis_client.rb

class InMemoryRedis
  attr_reader :redis

  def initialize
    @redis = {}
  end

  # REDIS.sadd store_name, picture.to_json
  def add_to_set(store_name, resource)
    redis[store_name] = [] unless redis.has_key?(store_name)
    redis[store_name].push resource.to_json
  end

  # REDIS.sscan_each(store_name, {match: "*#{picture_id}*"}).first
  def find_picture_in_set(store_name, picture_id)
    if redis.has_key?(store_name)
      redis[store_name].detect { |cached_picture| JSON.parse(cached_picture)["id"] == picture_id }
    end
  end

  # REDIS.sadd store_name, album.to_json
  def cache_album(album, store_name)
    redis[store_name] = [] unless redis.has_key?(store_name)
    redis[store_name].push album.to_json
  end

  # REDIS.sscan_each(store_name, {match: "*\"id\":#{album_id}*"}).first
  def get_cached_album(album_id, store_name)
    if redis.has_key?(store_name)
      album = redis[store_name].detect do |cached_album| 
        JSON.parse(cached_album)["id"] == album_id
      end
    end
  end

  # REDIS.srem store_name, resource.to_json
  def remove_from_set(store_name, resource)
    redis[store_name].delete resource.to_json if redis[store_name].present? 
  end

  # REDIS.del store_name
  def remove_all_from_set(store_name)
    redis[store_name] = []
  end

  # REDIS.srandmember(store_name, count)
  def random_members(store_name, count)
    if redis.has_key?(store_name)
      redis[store_name].sample(count)
    end
  end

  # REDIS.smembers store_name
  def get_members(store_name)
    redis.has_key?(store_name) ? redis[store_name] : []
  end

  # REDIS.scard store_name
  def get_members_count(store_name)
    redis[store_name].length
  end
end
