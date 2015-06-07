FactoryGirl.define do
  factory :user do
    first_name 'Steve'
    last_name 'Jones'
    sequence(:email) { |n| "person#{n}@aol.com" }
    password 'abc123'
  end

  factory :admin, parent: :user do
    after(:create) do |user|
      user.user_roles << create(:admin_user_role)
    end
  end

end
