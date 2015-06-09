require 'rails_helper'

describe Comment do

  it 'has a valid factory' do
    expect(build_stubbed(:comment)).to be_valid
  end

  it 'is invalid without content' do
    expect(build_stubbed(:comment, content: nil)).to have(1).errors_on(:content)
  end

  it 'is invalid without a user' do
    expect(build_stubbed(:comment, user: nil)).to have(1).errors_on(:user)
  end

  it 'is invalid without a post' do
    expect(build_stubbed(:comment, post: nil)).to have(1).errors_on(:post)
  end

end