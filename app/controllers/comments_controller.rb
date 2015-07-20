class CommentsController < ApplicationController

  before_action :authenticate_user!

  def create
    @comment = Comment.new(comment_params)
    authorize! :create, @comment
    respond_to do |format|
      if @comment.save
        format.js {}
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.js {}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize! :destroy, @comment
    respond_to do |format|
      if @comment.destroy
        format.js {}
      else
        format.js { head :ok }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(post_id: params[:post_id], user_id: current_user.id)
  end

end