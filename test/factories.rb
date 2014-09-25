include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password "password"
  end

  factory :category do
    user
  end

  factory :collection do
    name "test_collection"
    user
  end

  factory :monument do
    user
    category
    collection
  end

  factory :picture do
    monument
    sequence(:name) { |n| "Picture ##{n}" }
    description "Description"
    date "2014/01/01"
    image { fixture_file_upload 'test/fixtures/eifel_tower.jpg', 'image/jpg' }
  end
end