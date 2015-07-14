class PostsController < ApplicationController
  load_and_authorize_resource :goal
  load_and_authorize_resource :post, :through => :goal, :shallow => true
  before_filter :set_goal

  before_action :authenticate_user!

  def index
  end

  def new
  end

  def create

  end

  def edit
  end

  def update

  end

  def destroy
  end

  def post_params
    params.require(:post).permit(:title, :content, :goal_id)
  end

  protected

  def set_goal
    @goal ||= @post.goal
  end

end