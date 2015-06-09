FactoryGirl.define do
  factory :comment do
    content 'congrats on your long run!'
    post
    user
  end

end