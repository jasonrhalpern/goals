FactoryGirl.define do
  factory :post do
    title 'I went for a run'
    content 'Longest run of the year'
    goal
  end

  factory :post_with_comments, parent: :post do
    transient do
      comments_count 3
    end

    after(:create) do |post, evaluator|
      create_list(:comment, evaluator.comments_count, post: post)
    end
  end

end