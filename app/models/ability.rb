class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    alias_action :create, :read, :update, :destroy, :to => :crud
    alias_action :create, :update, :destroy, :to => :cud

    if user.has_role? :admin
      can :manage, :all
    else
      can :cud, User, :id => user.id
      can :crud, Location, :user_id => user.id
      can :crud, Payment, :user_id => user.id
      can :cud, Goal, :user_id => user.id
      can :cud, Milestone, :goal => { :user_id => user.id }
      can :cud, Post, :goal => { :user_id => user.id }
      can [:create, :destroy], Comment, :user_id => user.id
      can :create, Tag
      can [:create, :destroy], Relationship, :follower_id => user.id
      can :read, [User, Goal, Milestone, Post]
    end
  end
end