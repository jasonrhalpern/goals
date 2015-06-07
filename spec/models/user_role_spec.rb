require 'rails_helper'

describe UserRole do

  it 'has a valid factory' do
    expect(build_stubbed(:user_role)).to be_valid
  end

  it 'is invalid without a user' do
    expect(build_stubbed(:user_role, user: nil)).to have(1).errors_on(:user_id)
  end

  it 'is invalid without a role' do
    expect(build_stubbed(:user_role, role: nil)).to have(1).errors_on(:role_id)
  end

  it 'is invalid if the user is already associated with this role' do
    user_role1 = create(:user_role)
    expect(build_stubbed(:user_role, user_id: user_role1.user_id, role_id: user_role1.role_id)).to have(1).errors_on(:user_id)
  end

end