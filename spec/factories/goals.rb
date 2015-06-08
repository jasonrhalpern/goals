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
end