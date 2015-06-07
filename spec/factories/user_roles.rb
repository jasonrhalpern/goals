FactoryGirl.define do
  factory :user_role do
    user
    role
  end

  factory :admin_user_role, parent: :user_role do
    association :role, factory: :admin_role
  end
end