FactoryGirl.define do
  factory :goal do
    status :active
    title 'I am running a marathon this year'
    description 'I will do this by the end of January 2011!'
    user
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
end