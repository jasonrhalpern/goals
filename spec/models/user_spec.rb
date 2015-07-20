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

  it 'is invalid without a username' do
    expect(build_stubbed(:user, username: nil)).to have(1).errors_on(:username)
  end

  it 'is invalid without a unique username' do
    user = create(:user)
    expect(build_stubbed(:user, username: user.username.upcase)).to have(1).errors_on(:username)
  end

  it 'is invalid with a username that is too short' do
    user = create(:user)
    expect(build_stubbed(:user, username: 'd')).to have(1).errors_on(:username)
  end

  it 'is invalid with a username that is too long' do
    user = create(:user)
    expect(build_stubbed(:user, username: 'd' * 16)).to have(1).errors_on(:username)
  end

  it 'is invalid if the username doesn\'t have the right complexity' do
    expect(build_stubbed(:user, username: 'd45KWE_j')).to be_valid
    expect(build_stubbed(:user, username: 'jason')).to be_valid
    expect(build_stubbed(:user, username: 'd93er$#@')).to have(1).errors_on(:username)
    expect(build_stubbed(:user, username: 'dy 89K')).to have(1).errors_on(:username)
    expect(build_stubbed(:user, username: '  ')).to have(1).errors_on(:username)
    expect(build_stubbed(:user, username: '#$%(@#')).to have(1).errors_on(:username)
    expect(build_stubbed(:user, username: 'admin')).to have(1).errors_on(:username)
    expect(build_stubbed(:user, username: 'ADMIN')).to have(1).errors_on(:username)
    expect(build_stubbed(:user, username: 'Admin')).to have(1).errors_on(:username)
    expect(build_stubbed(:user, username: '4JAdmin')).to have(1).errors_on(:username)
    expect(build_stubbed(:user, username: 'MADMIN9P')).to have(1).errors_on(:username)
    expect(build_stubbed(:user, username: 'adminDFP')).to have(1).errors_on(:username)
    expect(build_stubbed(:user, username: 'adMIN$&')).to have(2).errors_on(:username)
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

  it 'has 3 goals' do
    expect(create(:user_with_goals).goals.count).to eq(3)
  end

  it 'destroys the associated goals' do
    user = create(:user_with_goals)
    goal_count = user.goals.count
    expect{ user.destroy }.to change{ Goal.count }.by(-goal_count)
  end

  it 'has 2 comments' do
    expect(create(:user_with_comments).comments.count).to eq(2)
  end

  it 'destroys the associated comments' do
    user = create(:user_with_comments)
    comment_count = user.comments.count
    expect{ user.destroy }.to change{ Comment.count }.by(-comment_count)
  end

  it 'destroys the associated user roles' do
    user = create(:user_with_roles)
    role_count = user.roles.count
    expect{ user.destroy }.to change{ UserRole.count }.by(-role_count)
  end

  it 'does not destroy the associated roles' do
    user = create(:user_with_roles)
    expect{ user.destroy }.not_to change{ Role.count }
  end

  it 'destroys the associated location' do
    user = create(:user_with_location)
    expect{ user.destroy }.to change{ Location.count }.by(-1)
  end

  it 'destroys the associated payment' do
    user = create(:user_with_active_payment)
    expect{ user.destroy }.to change{ Payment.count }.by(-1)
  end

  it 'is following 5 users' do
    expect(create(:user_with_followings).following.count).to eq(5)
  end

  it 'has a counter cache for following' do
    user1, user2 = create(:user), create(:user)
    expect{ user1.active_relationships.create(followed_id: user2.id) }.to change { User.first.following_count }.by(1)
  end

  it 'destroys the associated relationships in which the user is the follower' do
    user = create(:user_with_followings)
    expect{ user.destroy }.to change{ Relationship.count }.by(-5)
  end

  it 'does not destroy the associated followed users' do
    user = create(:user_with_followings)
    expect{ user.destroy }.to change{ User.count }.by(-1)
  end

  it 'has 4 followers' do
    expect(create(:user_with_followers).followers.count).to eq(4)
  end

  it 'has a counter cache for followers' do
    user1, user2 = create(:user), create(:user)
    expect{ user2.active_relationships.create(followed_id: user1.id) }.to change { User.first.followers_count }.by(1)
  end

  it 'destroys the associated relationships in which the user is being followed' do
    user = create(:user_with_followers)
    expect{ user.destroy }.to change{ Relationship.count }.by(-4)
  end

  it 'does not destroy the associated following users' do
    user = create(:user_with_followers)
    expect{ user.destroy }.to change{ User.count }.by(-1)
  end

  it 'returns a list of users with active payments' do
    user1 = create(:user_with_active_payment)
    user2 = create(:user_with_inactive_payment)

    expect(User.active).to eq([user1])
  end

  describe '#active?' do
    it 'returns true if the user is active' do
      user = build(:user_with_active_payment)
      expect(user.active?).to be_truthy
    end

    it 'returns false if the user is not active' do
      user = build(:user_with_inactive_payment)
      expect(user.active?).to be_falsey
    end
  end

  describe '#pending?' do
    it 'returns true if the user is pending' do
      user = build(:user)
      expect(user.pending?).to be_truthy
    end

    it 'returns false if the user is not pending' do
      user = build(:user_with_active_payment)
      expect(user.pending?).to be_falsey
    end
  end

  describe '#canceled?' do
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

  describe '#deactivated?' do
    it 'returns true if the user is deactivated' do
      user = build(:user_with_inactive_payment)
      expect(user.deactivated?).to be_truthy
    end

    it 'returns false if the user is active' do
      user = build(:user_with_active_payment)
      expect(user.deactivated?).to be_falsey
    end
  end

  describe '#follow' do
    it 'creates a relationship with another user' do
      user1, user2 = create(:user), create(:user)
      expect(user1.following?(user2)).to be_falsey
      user1.follow(user2)
      expect(user1.following?(user2)).to be_truthy
    end
  end

  describe '#unfollow' do
    it 'destroys a relationship with another user' do
      user1, user2 = create(:user), create(:user)
      user1.follow(user2)
      expect(user1.following?(user2)).to be_truthy
      user1.unfollow(user2)
      expect(user1.following?(user2)).to be_falsey
    end

  end

  describe '#following' do
    it 'returns true if a user is following another user' do
      user1, user2 = create(:user), create(:user)
      user1.follow(user2)
      expect(user1.following?(user2)).to be_truthy
    end

    it 'returns false if a user is not following another user' do
      user1, user2 = create(:user), create(:user)
      expect(user1.following?(user2)).to be_falsey
    end

    it 'returns the name of the user' do
      user = build(:user)
      expect(user.name).to eq(user.first_name + ' ' + user.last_name)
    end

  end

end
