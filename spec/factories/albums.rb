FactoryGirl.define do
  factory :album do
    title { Faker::Name.title }
    hashtags { Faker::Lorem.words }
    user

    factory :album_with_minimum_filters do
      min_likes_number { rand(1..10) * 10 }
      min_comments_number { rand(1..10) * 10 }
      min_followers_number { rand(1..10) * 10 }
    end

    factory :album_with_location do
      location { Faker::Address.country }
    end

    factory :album_with_pictures do
      after(:create) do |album, evaluator|
        create_list(:picture, 10, album: album)
      end
    end
  end
end
