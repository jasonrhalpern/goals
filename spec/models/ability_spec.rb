require 'rails_helper'

describe 'Ability' do
  describe 'User' do
    before(:each) do
      @user = create(:user)
      @user_two = create(:user)
      @ability = Ability.new(@user)
      @goal = build_stubbed(:goal, :user => @user)
      @goal_two = build_stubbed(:goal, :user => @user_two)
      @private_goal = build_stubbed(:private_goal, user: @user_two)
    end

    it "can crud himself, but not other users" do
      assert @ability.can?(:crud, @user)
      assert @ability.cannot?(:crud, User.new)
      assert @ability.cannot?(:crud, @user_two)
    end

    it "can crud his own location, but not the location of other users" do
      assert @ability.can?(:crud, Location.new(:user => @user))
      assert @ability.cannot?(:crud, Location.new)
      assert @ability.cannot?(:crud, Location.new(:user => @user_two))
    end

    it "can crud his own payment, but not the payment of other users" do
      assert @ability.can?(:crud, Payment.new(:user => @user))
      assert @ability.cannot?(:crud, Payment.new)
      assert @ability.cannot?(:crud, Payment.new(:user => @user_two))
    end

    it "can crud his own goals, but can't create, update or delete the goals of others" do
      assert @ability.can?(:crud, Goal.new(:user => @user))
      assert @ability.cannot?([:create, :update, :delete], Goal.new)
      assert @ability.cannot?([:create, :update, :delete], Goal.new(:user => @user_two))
    end

    it "can read the public goals of other users but not the private ones" do
      assert @ability.can?(:read, @goal_two)
      assert @ability.cannot?(:read, @private_goal)
    end

    it "can crud a milestone of his own goal, but can't create, update or delete the milestones of others" do
      assert @ability.can?(:crud, Milestone.new(:goal => @goal))
      assert @ability.cannot?([:create, :update, :delete], Milestone.new)
      assert @ability.cannot?([:create, :update, :delete], Milestone.new(:goal => @goal_two))
    end

    it "can read the public milestones of other users but not the private ones" do
      public_milestone = build(:milestone, goal: @goal_two)
      private_milestone = build(:milestone, goal: @private_goal)

      assert @ability.can?(:read, public_milestone)
      assert @ability.cannot?(:read, private_milestone)
    end

    it "can crud a post of his own goal, but can't create, update or delete the posts of others" do
      assert @ability.can?(:crud, Post.new(:goal => @goal))
      assert @ability.cannot?([:create, :update, :delete], Post.new)
      assert @ability.cannot?([:create, :update, :delete], Post.new(:goal => @goal_two))
    end

    it "can read the public posts of other users but not the private ones" do
      public_post = build(:post, goal: @goal_two)
      private_post = build(:post, goal: @private_goal)

      assert @ability.can?(:read, public_post)
      assert @ability.cannot?(:read, private_post)
    end

    it "can create and destroy his own comments, but not those of other users" do
      assert @ability.can?(:create, Comment.new(:user => @user))
      assert @ability.can?(:destroy, Comment.new(:user => @user))
      assert @ability.cannot?(:create, Comment.new(:user => @user_two))
      assert @ability.cannot?(:destroy, Comment.new(:user => @user_two))
    end

    it "can create tags" do
      assert @ability.can?(:create, Tag.new)
    end

    it "can create and destroy relationships in which the user is the follower" do
      assert @ability.can?(:create, Relationship.new(:follower => @user))
      assert @ability.can?(:destroy, Relationship.new(:follower => @user))
      assert @ability.cannot?(:create, Relationship.new(:followed => @user))
      assert @ability.cannot?(:destroy, Relationship.new(:followed => @user))
      assert @ability.cannot?(:create, Relationship.new(:follower => @user_two))
      assert @ability.cannot?(:destroy, Relationship.new(:follower => @user_two))
      assert @ability.cannot?(:create, Relationship.new(:followed => @user_two))
      assert @ability.cannot?(:destroy, Relationship.new(:followed => @user_two))
    end
  end

  describe 'Admin' do
    before(:each) do
      @admin = create(:admin)
      @ability = Ability.new(@admin)
      @admin_goal = create(:goal, :user => @admin)
    end

    it "can crud himself and other users" do
      assert @ability.can?(:crud, @admin)
      assert @ability.can?(:crud, User.new)
      assert @ability.can?(:crud, @user)
    end

    it "can crud his own location and those of other users" do
      assert @ability.can?(:crud, Location.new(:user => @admin))
      assert @ability.can?(:crud, Location.new)
      assert @ability.can?(:crud, Location.new(:user => @user))
    end

    it "can crud his own payment and those of other users" do
      assert @ability.can?(:crud, Payment.new(:user => @admin))
      assert @ability.can?(:crud, Payment.new)
      assert @ability.can?(:crud, Payment.new(:user => @user))
    end

    it "can crud his own goals and those of other users" do
      assert @ability.can?(:crud, Goal.new(:user => @admin))
      assert @ability.can?(:crud, Goal.new)
      assert @ability.can?(:crud, Goal.new(:user => @user))
    end

    it "can crud his own milestones and the milestones of others" do
      assert @ability.can?(:crud, Milestone.new(:goal => @admin_goal))
      assert @ability.can?(:crud, Milestone.new)
      assert @ability.can?(:crud, Milestone.new(:goal => @goal))
    end

    it "can crud his own posts and the posts of others" do
      assert @ability.can?(:crud, Post.new(:goal => @admin_goal))
      assert @ability.can?(:crud, Post.new)
      assert @ability.can?(:crud, Post.new(:goal => @goal))
    end

    it "can create and destroy his own comments and those of other users" do
      assert @ability.can?(:create, Comment.new(:user => @admin))
      assert @ability.can?(:destroy, Comment.new(:user => @admin))
      assert @ability.can?(:create, Comment.new(:user => @user))
      assert @ability.can?(:destroy, Comment.new(:user => @user))
    end

    it "can create tags" do
      assert @ability.can?(:create, Tag.new)
    end

    it "can create and destroy relationships" do
      assert @ability.can?(:create, Relationship.new)
      assert @ability.can?(:destroy, Relationship.new)
    end

  end
end