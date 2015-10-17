FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "Name#{n}" }
    user
  end
end