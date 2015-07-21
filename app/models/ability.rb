class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    alias_action :create, :read, :update, :destroy, :to => :crud
    alias_action :create, :update, :destroy, :to => :cud

    if user.has_role? :admin
      can :manage, :all
    else
      can :crud, User, :id => user.id
      can :crud, Location, :user_id => user.id
      can :crud, Payment, :user_id => user.id
      can :crud, Goal, :user_id => user.id
      can :crud, Milestone, :goal => { :user_id => user.id }
      can :crud, Post, :goal => { :user_id => user.id }
      can [:create, :destroy], Comment, :user_id => user.id
      can :create, Tag
      can [:create, :destroy], Relationship, :follower_id => user.id
      can :read, Goal, :visibility => 'publiced'
      can :read, Milestone, :goal => { :visibility => 'publiced' }
      can :read, Post, :goal => { :visibility => 'publiced' }
    end
  end
end