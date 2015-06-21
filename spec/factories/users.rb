FactoryGirl.define do
  factory :user, aliases: [:follower, :followed] do
    first_name 'Steve'
    last_name 'Jones'
    sequence(:email) { |n| "person#{n}@aol.com" }
    sequence(:username) { |n| "person#{n}" }
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

  factory :user_with_comments, parent: :user do
    transient do
      comments_count 2
    end

    after(:create) do |user, evaluator|
      create_list(:comment, evaluator.comments_count, user: user)
    end
  end

  factory :user_with_roles, parent: :user do
    transient do
      roles_count 3
    end

    after(:create) do |user, evaluator|
      create_list(:user_role, evaluator.roles_count, user: user)
    end
  end

  factory :user_with_location, parent: :user do
    after(:build) do |user|
      user.location ||= build(:location, :user => user)
    end
  end

  factory :user_with_followings, parent: :user do
    transient do
      following_count 5
    end

    after(:create) do |user, evaluator|
      create_list(:relationship, evaluator.following_count, follower: user)
    end
  end

  factory :user_with_followers, parent: :user do
    transient do
      followers_count 4
    end

    after(:create) do |user, evaluator|
      create_list(:relationship, evaluator.followers_count, followed: user)
    end
  end

end
