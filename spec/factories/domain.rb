FactoryGirl.define do
  factory :domain do
    name { Faker::Internet.domain_name.prepend ['www.', ''].sample }
    user
  end
end
