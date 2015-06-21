FactoryGirl.define do
  factory :location do
    address '4 Maple Drive'
    city 'Syosset'
    state 'NY'
    zip_code '11791'
    country 'US'
    user
  end
end