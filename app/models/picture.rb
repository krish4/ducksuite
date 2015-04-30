class Picture < ActiveRecord::Base
  belongs_to :album
  
  validates :instagram_id, presence: true
  validates :album, presence: true

  scope :accepted, -> { where(status: "accepted") }

  state_machine :status, :initial => :new do
    event :accept do
      transition [:new, :denied] => :accepted
    end

    event :deny do
      transition [:new, :accepted] => :denied
    end

    event :clear do
      transition [:accepted, :denied] => :new
    end
  end

end
