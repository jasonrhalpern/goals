require 'rails_helper'

describe User do

  it 'has a valid factory' do
    expect(build_stubbed(:user)).to be_valid
  end

  it 'is invalid without a first name' do
    expect(build_stubbed(:user, first_name: nil)).to have(1).errors_on(:first_name)
  end

  it 'is invalid without a last name' do
    expect(build_stubbed(:user, last_name: nil)).to have(1).errors_on(:last_name)
  end

  it 'is invalid without an email' do
    expect(build_stubbed(:user, email: nil)).to have(2).errors_on(:email)
  end

  it 'is invalid without a valid email address' do
    expect(build_stubbed(:user, email: 'test.com')).to have(1).errors_on(:email)
  end

  it 'is invalid without a unique email' do
    create(:user, email: 'test@aol.com')
    expect(build_stubbed(:user, email: 'test@aol.com')).to have(1).errors_on(:email)
  end

  it 'is invalid with a password that is too short' do
    expect(build_stubbed(:user, password: 'pw4$')).to have(1).errors_on(:password)
  end

  it 'is invalid with a password that is too long' do
    expect(build_stubbed(:user, password: 'w3#' * 7)).to have(1).errors_on(:password)
  end

  it 'is invalid with a password that doesn\'t have the right complexity' do
    expect(build_stubbed(:user, password: 'password')).to have(1).errors_on(:password)
  end

  it 'does not have a role' do
    expect(create(:user).roles.count).to eq(0)
  end

  it 'has an admin role' do
    expect(create(:admin).roles.count).to eq(1)
  end

end
