require 'rails_helper'

describe Goal do

  it 'has a valid factory' do
    expect(build_stubbed(:goal)).to be_valid
  end

  it 'is invalid without a title' do
    expect(build_stubbed(:goal, title: nil)).to have(1).errors_on(:title)
  end

  it 'is invalid if the title is too long' do
    expect(build_stubbed(:goal, title: 'w3#ew' * 17)).to have(1).errors_on(:title)
  end

  it 'is invalid if the title is not unique for this user' do
    goal = create(:goal)
    expect(build_stubbed(:goal, user: goal.user, title: goal.title)).to have(1).errors_on(:title)
  end

  it 'is invalid without a description' do
    expect(build_stubbed(:goal, description: nil)).to have(1).errors_on(:description)
  end

  it 'is invalid if the description is too long' do
    expect(build_stubbed(:goal, description: 'w3#ew' * 161)).to have(1).errors_on(:description)
  end

  it 'is invalid without a status' do
    expect(build_stubbed(:goal, status: nil)).to have(1).errors_on(:status)
  end

  it 'is invalid without a visibility' do
    expect(build_stubbed(:goal, visibility: nil)).to have(1).errors_on(:visibility)
  end

  it 'is invalid without a user' do
    expect(build_stubbed(:goal, user: nil)).to have(1).errors_on(:user)
  end

  it 'is invalid if this user already has two active goals' do
    goal_1 = create(:goal)
    goal_2 = create(:goal, :user => goal_1.user)
    expect(build(:goal, user: goal_2.user)).to have(1).errors_on(:base)
  end

  it 'is associated with 3 tags' do
    expect(create(:goal_with_tags).tags.count).to eq(3)
  end

  it 'is associated with 3 goal tags' do
    expect(create(:goal_with_tags).goal_tags.count).to eq(3)
  end

  it 'is associated with 2 milestones' do
    expect(create(:goal_with_milestones).milestones.count).to eq(2)
  end

  it 'is associated with 2 posts' do
    expect(create(:goal_with_posts).posts.count).to eq(2)
  end

  it 'destroys the associated goal tags' do
    goal = create(:goal_with_tags)
    goal_tag_count = goal.goal_tags.count
    expect{ goal.destroy }.to change{ GoalTag.count }.by(-goal_tag_count)
  end

  it 'does not destroy the associated tags' do
    goal = create(:goal_with_tags)
    expect{ goal.destroy }.not_to change{ Tag.count }
  end

  it 'destroys the associated posts' do
    goal = create(:goal_with_posts)
    posts_count = goal.posts.count
    expect{ goal.destroy }.to change{ Post.count }.by(-posts_count)
  end

  it 'destroys the associated milestones' do
    goal = create(:goal_with_milestones)
    milestones_count = goal.milestones.count
    expect{ goal.destroy }.to change{ Milestone.count }.by(-milestones_count)
  end



end