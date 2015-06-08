FactoryGirl.define do
  factory :tag do
    sequence(:name) { |n| "Tag #{n}" }
  end

  factory :tag_with_goals, parent: :tag do
    transient do
      goals_count 3
    end

    after(:create) do |tag, evaluator|
      create_list(:goal_tag, evaluator.goals_count, tag: tag)
    end
  end
end