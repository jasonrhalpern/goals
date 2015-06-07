FactoryGirl.define do
  factory :role do
    sequence(:name) { |n| "Role #{n}" }
  end

  factory :admin_role, parent: :role do
    name 'Admin'
  end

  factory :role_with_users, parent: :role do
    transient do
      users_count 2
    end

    after(:create) do |role, evaluator|
      create_list(:user_role, evaluator.users_count, role: role)
    end
  end
end