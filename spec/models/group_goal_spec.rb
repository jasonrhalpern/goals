require 'rails_helper'

describe GroupGoal do

  it 'has a valid factory' do
    expect(build_stubbed(:group_goal)).to be_valid
  end

  it 'is a type of Goal class' do
    expect(build_stubbed(:group_goal)).to be_a_kind_of(Goal)
  end

end