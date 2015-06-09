FactoryGirl.define do
  factory :milestone do
    status :open
    description 'My first 5k'
    reach_by_date Date.tomorrow
    goal
  end

end
