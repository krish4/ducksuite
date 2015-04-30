class CachePictures
  def initialize(pictures, album_id, redisDb, are_new_pictures = false)
    @album_id         = album_id
    @pictures         = pictures
    @redisDb          = redisDb
    @are_new_pictures = are_new_pictures
  end

  def call
    cache_pictures(@pictures)
  end

  private
  attr_reader :album_id, :are_new_pictures, :redisDb

  def cache_pictures(pictures)
    fetched_at = Time.now
    pictures.map do |picture|
      if is_picture_not_cached?(picture[:id])
        picture["fetched_at"] = fetched_at
        cache_picture(picture)
        picture
      end
    end.compact
  end

  def is_picture_not_cached?(picture_id)
    [ redisDb.find_picture_in_set(new_album_name, picture_id),
      redisDb.find_picture_in_set(old_album_name, picture_id),
      redisDb.find_picture_in_set(denied_album_name, picture_id),
      redisDb.find_picture_in_set(accepted_album_name, picture_id) ].all? &:nil?
  end

  def cache_picture(picture)
    redisDb.add_to_set(album_name, picture)
  end

  def album_name
    if are_new_pictures then new_album_name else old_album_name end
  end

  def old_album_name
    CacheName.old_album_name(album_id)
  end

  def new_album_name
    CacheName.new_album_name(album_id)
  end

  def accepted_album_name
    CacheName.accepted_album_name(album_id)
  end

  def denied_album_name
    CacheName.denied_pictures_store(album_id)
  end
end
