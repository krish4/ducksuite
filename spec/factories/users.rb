FactoryGirl.define do
  factory :user do
    name { Faker::Name.first_name + " " + Faker::Name.last_name }
    sequence(:email) { |n| "#{n}" + Faker::Internet.email }
    password { Faker::Internet.password(8) }

    factory :user_with_album do
      after(:create) { |user, _| create(:album, user: user) }
    end

    factory :user_with_albums do
      after(:create) { |user, _| create_list(:album, 3, user: user) }
    end
  end
end
