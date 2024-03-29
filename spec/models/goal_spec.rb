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
    goal_3 = create(:goal, :user => goal_1.user)
    expect(build(:goal, user: goal_1.user)).to have(1).errors_on(:base)
  end

  it 'is invalid if this goal has more than 3 tags' do
    expect(create(:goal_with_too_many_tags)).to have(1).errors_on(:base)
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

  it 'returns the viewable public goals' do
    goal1 = create(:goal)
    goal2 = create(:private_goal)
    goal3 = create(:goal)
    goal4 = create(:group_goal)
    expect(Goal.viewable).to eq([goal3, goal1])
  end

  it 'returns all the personal goals' do
    goal1 = create(:group_goal)
    goal2 = create(:goal)
    goal3 = create(:goal)
    expect(Goal.personal_goals).to eq([goal3, goal2])
  end

  it 'returns all the group goals' do
    goal1 = create(:group_goal)
    goal2 = create(:group_goal)
    goal3 = create(:goal)
    expect(Goal.group_goals).to eq([goal1, goal2])
  end

  describe 'personal_goal?' do
    it 'returns true if the goal is a personal goal' do
      expect(build_stubbed(:goal).personal_goal?).to be_truthy
    end

    it 'returns false if the goal is a group goal' do
      expect(build_stubbed(:group_goal).personal_goal?).to be_falsey
    end
  end

  describe 'group_goal?' do
    it 'returns true if the goal is a group goal' do
      expect(build_stubbed(:group_goal).group_goal?).to be_truthy
    end

    it 'returns false if the goal is a personal goal' do
      expect(build_stubbed(:goal).group_goal?).to be_falsey
    end
  end
end