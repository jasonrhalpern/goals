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

  factory :user_with_goals, parent: :user do
    transient do
      goals_count 3
    end

    after(:create) do |user, evaluator|
      create_list(:completed_goal, evaluator.goals_count, user: user)
    end
  end

  factory :user_with_active_payment, parent: :user do
    after(:build) do |user|
      user.payment ||= build(:payment, :user => user)
    end
  end

  factory :user_with_inactive_payment, parent: :user do
    after(:build) do |user|
      user.payment ||= build(:inactive_payment, :user => user)
    end
  end

end
