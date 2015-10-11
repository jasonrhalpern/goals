FactoryGirl.define do
  factory :goal do
    sequence(:title) { |n| "title#{n}" }
    sequence(:description) { |n| "description#{n}" }
    visibility :publiced
    status :active
    type 'PersonalGoal'
    user
  end

  factory :private_goal, parent: :goal  do
    visibility :privated
  end

  factory :completed_goal, parent: :goal do
    status :closed
  end

  factory :goal_with_tags, parent: :goal do
    transient do
      tags_count 3
    end

    after(:create) do |goal, evaluator|
      create_list(:goal_tag, evaluator.tags_count, goal: goal)
    end
  end

  factory :goal_with_too_many_tags, parent: :goal do
    transient do
      tags_count 4
    end

    after(:create) do |goal, evaluator|
      create_list(:goal_tag, evaluator.tags_count, goal: goal)
    end
  end

  factory :goal_with_posts, parent: :goal do
    transient do
      posts_count 2
    end

    after(:create) do |goal, evaluator|
      create_list(:post, evaluator.posts_count, goal: goal)
    end
  end

  factory :goal_with_milestones, parent: :goal do
    transient do
      milestones_count 2
    end

    after(:create) do |goal, evaluator|
      create_list(:milestone, evaluator.milestones_count, goal: goal)
    end
  end

  factory :personal_goal, parent: :goal, class: 'PersonalGoal' do
  end

  factory :group_goal, parent: :goal, class: 'GroupGoal' do
  end
end