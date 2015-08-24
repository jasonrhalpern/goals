class RelationshipsController < ApplicationController

  before_action :authenticate_user!

  def create
    @user = User.find(params[:followed_id])
    authorize! :create, Relationship.new(followed: @user, follower: current_user)
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @relationship = Relationship.find(params[:id])
    @user = @relationship.followed
    authorize! :destroy, @relationship
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  private

  def relationship_params
    params.require(:relationship).permit(:followed_id, :follower_id)
  end

end