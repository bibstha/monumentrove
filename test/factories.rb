FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password "password"
  end

  factory :category do
    user
  end

  factory :collection do
    user
  end

  factory :monument do
    user
    category
    collection
  end

  factory :picture do
    monument
  end
end