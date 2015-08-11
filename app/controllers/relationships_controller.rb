class RelationshipsController < ApplicationController

  before_action :authenticate_user!

  def create
    @relationship = Relationship.new(followed_id: params[:user_id], follower_id: current_user.id)
    authorize! :create, @relationship
    respond_to do |format|
      if @relationship.save
        format.js { render :toggle }
      else
        format.js { render :toggle }
      end
    end
  end

  def destroy
    @relationship = Relationship.find(params[:id])
    authorize! :destroy, @relationship
    respond_to do |format|
      if @relationship.destroy
        format.js { render :toggle }
      else
        format.js { render :toggle }
      end
    end
  end

  private

  def relationship_params
    params.require(:relationship).permit(:followed_id, :follower_id)
  end

end