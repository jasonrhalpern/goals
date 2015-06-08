FactoryGirl.define do
  factory :payment do
    sequence(:stripe_cus_token) { |n| "cus_#{n}" }
    sequence(:stripe_sub_token) { |n| "sub_#{n}" }
    active_until 1.day.from_now
    user
  end

  factory :inactive_payment, parent: :payment do
    active_until 1.day.ago
  end

end