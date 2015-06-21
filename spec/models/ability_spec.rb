require 'rails_helper'

describe 'Ability' do
  describe 'User' do
    before(:each) do
      @user = create(:user)
      @user_two = create(:user)
      @ability = Ability.new(@user)
      @goal = create(:goal, :user => @user)
      @goal_two = create(:goal, :user => @user_two)
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

    it "can crud his own goals, but not the goals of other users" do
      assert @ability.can?(:crud, Goal.new(:user => @user))
      assert @ability.cannot?(:crud, Goal.new)
      assert @ability.cannot?(:crud, Goal.new(:user => @user_two))
    end

    it "can crud a milestone of his own goal, but not the milestones of others" do
      assert @ability.can?(:crud, Milestone.new(:goal => @goal))
      assert @ability.cannot?(:crud, Milestone.new)
      assert @ability.cannot?(:crud, Milestone.new(:goal => @goal_two))
    end

    it "can crud a post of his own goal, but not the posts of others" do
      assert @ability.can?(:crud, Post.new(:goal => @goal))
      assert @ability.cannot?(:crud, Post.new)
      assert @ability.cannot?(:crud, Post.new(:goal => @goal_two))
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