FactoryGirl.define do
  factory :milestone do
    status :open
    title 'My first 5k'
    description 'Killing the runs'
    reach_by_date Date.tomorrow
    goal
  end

end
