class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  has_many :albums, dependent: :destroy
  has_many :domains, dependent: :destroy
  has_many :authentications, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def is_authenticated(provider)
    Authentication.exists? user_id: id, provider: provider
  end

  def get_access_token(provider)
    self.authentications.find_by(provider: provider).access_token
  end

  def inbox_count
    albums.map { |album| CountInboxPictures.new(RedisClient.new, album.id, true).call }.sum
  end

  # It sets Instagram client. If current user is connected to Instagram, use
  # its account to request instagram's API. Otherwise, use ducksuite account.
  def self.get_instagram_client(user)
    access_token = user && user.is_authenticated("instagram") ? user.get_access_token("instagram") : ENV["INSTAGRAM_ACCESS_TOKEN"]
    Instagram.client(access_token: access_token)
  end

  def pictures_in_albums_number
    albums.map { |album| album.pictures_number }.sum
  end
end
