FactoryGirl.define do
  factory :user do
    first_name 'Steve'
    last_name 'Jones'
    sequence(:email) { |n| "person#{n}@aol.com" }
    password 'abc123'
  end

end
