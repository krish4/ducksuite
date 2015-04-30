FactoryGirl.define do
  factory :picture do
    instagram_id { Faker::Number.number(10) }
    album
  end
end
