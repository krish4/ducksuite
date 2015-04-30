class RetrievePicturesFromCache
  def initialize(album_name, redisDb)
    @album_name = album_name
    @redisDb = redisDb
  end

  def call
    @redisDb.remove_from_set(@album_name, nil)
    @redisDb.get_members(@album_name).map do |picture|
      JSON.parse(picture)
    end
  end
end
