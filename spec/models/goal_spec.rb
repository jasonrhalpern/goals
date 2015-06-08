require 'rails_helper'

describe Goal do

  it 'has a valid factory' do
    expect(build_stubbed(:goal)).to be_valid
  end

  it 'is invalid without a title' do
    expect(build_stubbed(:goal, title: nil)).to have(1).errors_on(:title)
  end

  it 'is invalid without a description' do
    expect(build_stubbed(:goal, description: nil)).to have(1).errors_on(:description)
  end

  it 'is invalid without a status' do
    expect(build_stubbed(:goal, status: nil)).to have(1).errors_on(:status)
  end

  it 'is invalid without a user' do
    expect(build_stubbed(:goal, user: nil)).to have(1).errors_on(:user)
  end

  it 'is invalid if this user already has an active goal' do
    goal = create(:goal)
    expect(build_stubbed(:goal, user: goal.user)).to have(1).errors_on(:title)
  end

end