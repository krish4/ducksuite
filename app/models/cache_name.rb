module CacheName
  def self.old_album_name(album_id)
    "album_#{album_id}"
  end

  def self.new_album_name(album_id)
    "album_#{album_id}_new"
  end

  def self.accepted_album_name(album_id)
    "album_#{album_id}_accepted"
  end

  def self.denied_pictures_store(album_id)
    "album_#{album_id}_denied"
  end

  def self.user_albums_name(user_id)
    "user_#{user_id}_albums"
  end

  def self.inbox_album_name(album_id)
    "inbox_#{album_id}"
  end

  def self.inbox_notifications(album_id)
    "inbox_#{album_id}_notifications"
  end
end