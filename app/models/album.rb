class Album < ActiveRecord::Base
  belongs_to :user
  has_many :pictures, dependent: :destroy
  has_one :location, inverse_of: :album, dependent: :destroy
  accepts_nested_attributes_for :location, reject_if: :all_blank

  attr_accessor :current_user

  after_create :create_inbox
  before_save :set_minimal_thresholds_as_integers

  validates_presence_of :user, :title, :hashtags
  validates :min_followers_number, 
            :min_likes_number, 
            :min_comments_number, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true

  def self.find_by_main_hashtag(main_hashtag)
    Album.where("? = ANY(hashtags)", main_hashtag)
  end

  def main_hashtag
    InstagramProvider.new(current_user).get_main_hashtag(hashtags)
  end

  def satisfy_most_album_settings?(picture)
    contains_all_tags?(picture.tags) && matches_filters?(picture)        
  end

  def contains_all_tags?(tags)
    (hashtags - tags).empty?
  end

  def matches_filters?(picture)
    matches_likes_number?(picture)     && 
    matches_comments_number?(picture)  && 
    matches_location?(picture)
  end

  def pictures_number
    pictures = RetrievePicturesFromCache.new(CacheName.accepted_album_name(self.id), RedisClient.new).call
    pictures.count
  end

  def create_instagram_subscription(callback_url)
    begin
      subscription_params = { 
        object: "tag", 
        callback_url: callback_url, 
        aspect: "media", 
        object_id: main_hashtag
      }
      Instagram.create_subscription(subscription_params) 
    rescue Instagram::TooManyRequests
      logger.error  "Failed to create subscription for the following hashtag: #{main_hashtag} " +
                    "(Instagram: The maximum number of requests per hour has been exceeded.)"
    end
  end

  def matches_followers_number?(picture)
    return true if min_followers_number.zero?
    min_followers_number <= picture[:followers_number]
  end

  private
    def create_inbox
      Inbox.new(self.id).save
    end

    def set_minimal_thresholds_as_integers
      self.min_likes_number     = min_likes_number.to_i
      self.min_comments_number  = min_comments_number.to_i
      self.min_followers_number = min_followers_number.to_i
    end

    def matches_likes_number?(picture)
      min_likes_number <= picture.likes["count"]
    end

    def matches_comments_number?(picture)
      min_comments_number <= picture.comments["count"]
    end

    def matches_location?(picture)
      return true  unless location.present? 
      return false unless picture.location? && picture.location.latitude? && picture.location.longitude?
      location.area_contains?(picture.location.latitude, picture.location.longitude)
    end

    def handle_instagram_picture_error(picture)
      # Remove picture from the database, because user probably removed 
      # the picture from the Instagram or changed its view permissions.
      picture.destroy if picture.present?
    end
end
