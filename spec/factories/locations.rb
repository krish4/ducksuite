FactoryGirl.define do
  factory :location do
    name { Faker::Address.country }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    radius { rand(1..10000) }
    album
  end
end
