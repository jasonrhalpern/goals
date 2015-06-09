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

  it 'is has 3 goals' do
    expect(create(:user_with_goals).goals.count).to eq(3)
  end

  it 'is has 2 comments' do
    expect(create(:user_with_comments).comments.count).to eq(2)
  end

  describe 'active?' do
    it 'returns true if the user is active' do
      user = build(:user_with_active_payment)
      expect(user.active?).to be_truthy
    end

    it 'returns false if the user is not active' do
      user = build(:user_with_inactive_payment)
      expect(user.active?).to be_falsey
    end
  end

  describe 'pending?' do
    it 'returns true if the user is pending' do
      user = build(:user)
      expect(user.pending?).to be_truthy
    end

    it 'returns false if the user is not pending' do
      user = build(:user_with_active_payment)
      expect(user.pending?).to be_falsey
    end
  end

  describe 'canceled?' do
    it 'returns true if the user is canceled' do
      payment = build(:payment, :stripe_sub_token => nil)
      user = build(:user, :payment => payment)
      expect(user.canceled?).to be_truthy
    end

    it 'returns false if the user is not canceled' do
      payment = build(:payment)
      user = build(:user, :payment => payment)
      expect(user.canceled?).to be_falsey
    end
  end

  describe 'deactivated?' do
    it 'returns true if the user is deactivated' do
      user = build(:user_with_inactive_payment)
      expect(user.deactivated?).to be_truthy
    end

    it 'returns false if the user is active' do
      user = build(:user_with_active_payment)
      expect(user.deactivated?).to be_falsey
    end
  end

  it 'returns a list of users with active payments' do
    user1 = create(:user_with_active_payment)
    user2 = create(:user_with_inactive_payment)

    expect(User.active).to eq([user1])
  end

end
