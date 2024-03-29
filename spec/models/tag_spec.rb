require 'rails_helper'

describe Tag do

  it 'has a valid factory' do
    expect(build_stubbed(:tag)).to be_valid
  end

  it 'is invalid without a name' do
    expect(build_stubbed(:tag, name: nil)).to have(1).errors_on(:name)
  end

  it 'is invalid without a unique name' do
    tag = create(:tag)
    expect(build_stubbed(:tag, name: tag.name)).to have(1).errors_on(:name)
  end

  it 'is associated with 3 goals' do
    expect(create(:tag_with_goals).goals.count).to eq(3)
  end

  it 'is associated with 3 goal tags' do
    expect(create(:tag_with_goals).goal_tags.count).to eq(3)
  end

  it 'destroys the associated goal tags' do
    tag = create(:tag_with_goals)
    goal_tag_count = tag.goal_tags.count
    expect{ tag.destroy }.to change{ GoalTag.count }.by(-goal_tag_count)
  end

  it 'does not destroy the associated goals' do
    tag = create(:tag_with_goals)
    expect{ tag.destroy }.not_to change{ Goal.count }
  end

end