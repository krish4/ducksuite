class RemoveAcceptedFromCache < RemoveFromCache

  def call
    redis_db.remove_from_set(cached_album_name, picture)
  end

  private
  def cached_album_name
    CacheName.accepted_album_name(album_id)
  end
end
