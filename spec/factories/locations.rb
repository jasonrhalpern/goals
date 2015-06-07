FactoryGirl.define do
  factory :location do
    address_line_1 '4 Maple Drive'
    address_line_2 'Apartment #4B'
    city 'Syosset'
    state 'NY'
    zip_code '11791'
    country 'US'
    user
  end
end