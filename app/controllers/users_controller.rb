class UsersController < ApplicationController
  load_resource :user

  before_action :authenticate_user!, :only => []

  def show
    @user = User.includes(:goals).find(params[:id])
  end

  def followers
    @title = "Followers"
    @users = @user.followers.page(params[:page]).per(20)
    render 'show_follow'
  end

  def following
    @title = "Following"
    @users = @user.following.page(params[:page]).per(20)
    render 'show_follow'
  end

end