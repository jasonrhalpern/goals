class UsersController < ApplicationController

  def followers
    @followers = Relationship.includes(:follower).where(followed_id: params[:id]).page(params[:page]).per(20)
  end

  def followings
    @followings = Relationship.includes(:followed).where(follower_id: params[:id]).page(params[:page]).per(20)
  end

end