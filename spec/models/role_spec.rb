require 'rails_helper'

describe Role do

  it 'has a valid factory' do
    expect(build_stubbed(:role)).to be_valid
  end

  it 'is invalid without a name' do
    expect(build_stubbed(:role, name: nil)).to have(1).errors_on(:name)
  end

  it 'is invalid without a unique name' do
    create(:role, name: 'admin')
    expect(build_stubbed(:role, name: 'admin')).to have(1).errors_on(:name)
  end

  it 'is associated with 2 users' do
    expect(create(:role_with_users).users.count).to eq(2)
  end

  it 'is associated with 2 user roles' do
    expect(create(:role_with_users).user_roles.count).to eq(2)
  end

end