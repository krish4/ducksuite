class CountInboxPictures

  def initialize(redis_db, album_id, count_only_new = false)
    @redis_db = redis_db
    @album_id = album_id
    @count_only_new = count_only_new
  end

  def call
    count_only_new ? count_unseen_pictures : all_pictures.count
  end

  private
  attr_reader :redis_db, :album_id, :count_only_new

  def all_pictures
    @all_pictures ||= begin
      RetrievePicturesFromCache.new(CacheName.old_album_name(album_id), redis_db).call +
      RetrievePicturesFromCache.new(CacheName.new_album_name(album_id), redis_db).call
    end
  end

  def count_unseen_pictures
    return all_pictures.count unless last_visited_inbox_at.present?
    all_pictures.compact.map do |pic| 
      Time.parse(pic["fetched_at"]) > Time.parse(last_visited_inbox_at)
    end.count(true)
  end

  def last_visited_inbox_at
    @last_visited_inbox_at ||= JSON.parse(inbox)["last_visited_at"] if inbox.present?
  end

  def inbox
    @inbox ||= REDIS.get CacheName.inbox_album_name(album_id)
  end
end