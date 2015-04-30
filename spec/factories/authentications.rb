FactoryGirl.define do
  factory :authentication do
    uid { Faker::Number.number(10) }
    provider { ["instagram", "facebook"].sample }
    access_token { Faker::Number.number(20) }
    user
  end
end
