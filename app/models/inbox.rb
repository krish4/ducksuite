class Inbox

  def initialize(album_id)
    @album_id = album_id
    @look_for_older_pictures = look_for_older_pictures
    @last_fetched_min_id = last_fetched_min_id
    @last_fetched_max_id = last_fetched_max_id
    @current_min_id = current_min_id
    @current_max_id = current_max_id
    @pending_pictures = pending_pictures
    @last_visited_at = last_visited_at
  end

  def update(options = {})
    @look_for_older_pictures = options.fetch(:look_for_older_pictures, look_for_older_pictures)
    @last_fetched_min_id = options.fetch(:last_fetched_min_id, last_fetched_min_id)
    @last_fetched_max_id = options.fetch(:last_fetched_max_id, last_fetched_max_id)
    @current_min_id = options.fetch(:current_min_id, current_min_id)
    @current_max_id = options.fetch(:current_max_id, current_max_id)
    @pending_pictures = options.fetch(:pending_pictures, pending_pictures)
    @last_visited_at = options.fetch(:last_visited_at, last_visited_at)
    self.save
  end

  def increase_pending_pictures(number = 1)
    @pending_pictures += number
    self.save
  end

  def decrease_pending_pictures(number = 1)
    @pending_pictures = [@pending_pictures - number, 0].max
    self.save
  end

  def save
    REDIS.set inbox_name, body
  end

  def pending_pictures
    @pending_pictures ||= JSON.parse(current_inbox)["pending_pictures"].to_i
  end

  def last_visited_at
    @last_visited_at ||= JSON.parse(current_inbox)["last_visited_at"]
  end

  def visited!
    update({ last_visited_at: Time.now })
  end

  private
  def inbox_name
    CacheName.inbox_album_name(@album_id)
  end

  def body
    {
      look_for_older_pictures: look_for_older_pictures,
      last_fetched_min_id: last_fetched_min_id,
      last_fetched_max_id: last_fetched_max_id,
      current_min_id: current_min_id,
      current_max_id: current_max_id,
      pending_pictures: pending_pictures,
      last_visited_at: last_visited_at
    }.to_json
  end

  def current_inbox
    @current_inbox ||= begin
      REDIS.get(inbox_name) || {}.to_json
    end
  end

  def look_for_older_pictures
    return @look_for_older_pictures if @look_for_older_pictures
    @look_for_older_pictures = JSON.parse(current_inbox)["look_for_older_pictures"] || true
  end

  def last_fetched_min_id
    @last_fetched_min_id ||= JSON.parse(current_inbox)["last_fetched_min_id"]
  end

  def last_fetched_max_id
    @last_fetched_max_id ||= JSON.parse(current_inbox)["last_fetched_max_id"]
  end

  def current_min_id
    @current_min_id ||= JSON.parse(current_inbox)["current_min_id"]
  end

  def current_max_id
    @current_max_id ||= JSON.parse(current_inbox)["current_max_id"]
  end

  end