require 'rails_helper'

describe Relationship do

  it 'has a valid factory' do
    expect(build_stubbed(:relationship)).to be_valid
  end

  it 'is invalid without a followed user' do
    expect(build_stubbed(:relationship, followed: nil)).to have(1).errors_on(:followed)
  end

  it 'is invalid without a follower' do
    expect(build_stubbed(:relationship, follower: nil)).to have(1).errors_on(:follower)
  end

  it 'is invalid if a user is already following this other user' do
    user = create(:relationship)
    expect(build_stubbed(:relationship, follower: user.follower, followed: user.followed)).to have(1).errors_on(:followed_id)
  end

end