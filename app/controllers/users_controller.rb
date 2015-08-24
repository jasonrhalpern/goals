class UsersController < ApplicationController
  load_resource :user

  before_action :authenticate_user!, :only => []

  def show
    @user = User.includes(:goals).find(params[:id])
  end

  def followers
    @title = "Followers"
    @relationships = Relationship.includes(:follower).where(followed_id: params[:id]).page(params[:page]).per(20)
    render 'show_follow'
  end

  def following
    @title = "Following"
    @relationships = Relationship.includes(:followed).where(follower_id: params[:id]).page(params[:page]).per(20)
    render 'show_follow'
  end

end