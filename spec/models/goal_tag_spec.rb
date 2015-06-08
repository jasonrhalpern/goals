require 'rails_helper'

describe GoalTag do

  it 'has a valid factory' do
    expect(build_stubbed(:goal_tag)).to be_valid
  end

  it 'is invalid without a goal' do
    expect(build_stubbed(:goal_tag, goal: nil)).to have(1).errors_on(:goal_id)
  end

  it 'is invalid without a tag' do
    expect(build_stubbed(:goal_tag, tag: nil)).to have(1).errors_on(:tag_id)
  end

  it 'is invalid if the tag is already associated with this goal' do
    goal_tag1 = create(:goal_tag)
    expect(build_stubbed(:goal_tag, goal_id: goal_tag1.goal_id, tag_id: goal_tag1.tag_id)).to have(1).errors_on(:tag_id)
  end

end