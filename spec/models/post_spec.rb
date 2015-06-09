require 'rails_helper'

describe Post do

  it 'has a valid factory' do
    expect(build_stubbed(:post)).to be_valid
  end

  it 'is invalid without a title' do
    expect(build_stubbed(:post, title: nil)).to have(1).errors_on(:title)
  end

  it 'is invalid with a title that is too long' do
    expect(build_stubbed(:post, title: 'great' * 11)).to have(1).errors_on(:title)
  end

  it 'is invalid without content' do
    expect(build_stubbed(:post, content: nil)).to have(1).errors_on(:content)
  end

  it 'is invalid without a goal' do
    expect(build_stubbed(:post, goal: nil)).to have(1).errors_on(:goal)
  end


end