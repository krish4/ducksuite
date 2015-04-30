class Authentication < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user, :uid, :provider
  validates :provider, inclusion: { in: %w(instagram facebook) }

end
