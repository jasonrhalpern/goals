class RelationshipsController < ApplicationController

  before_action :authenticate_user!

  def create
    @relationship = Relationship.new(relationship_params)
    @user = @relationship.followed
    authorize! :create, @relationship
    respond_to do |format|
      if @relationship.save
        format.html { redirect_to @user }
        format.js
      else
        format.html { redirect_to @user }
        format.js
      end
    end
  end

  def destroy
    @relationship = Relationship.find(params[:id])
    @user = @relationship.followed
    authorize! :destroy, @relationship
    @relationship.destroy
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  private

  def relationship_params
    params.require(:relationship).permit(:followed_id).merge(follower_id: current_user.id)
  end

end