class UsersController < ApplicationController
  load_resource :user

  before_action :authenticate_user!, :only => []

  def show
    @user = User.includes(:goals).find(params[:id])
  end

  def followers
    @followers = Relationship.includes(:follower).where(followed_id: params[:id]).page(params[:page]).per(20)
  end

  def following
    @following = Relationship.includes(:followed).where(follower_id: params[:id]).page(params[:page]).per(20)
  end

end