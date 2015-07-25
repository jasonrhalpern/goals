class PostsController < ApplicationController
  load_and_authorize_resource :goal
  load_and_authorize_resource :post, :through => :goal, :shallow => true
  before_filter :set_goal

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @posts = @posts.includes(:comments => :user).order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
  end

  def create
    if @post.save
      redirect_to goal_posts_path(@goal), notice: 'This post was successfully saved.'
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update_attributes(post_params)
      redirect_to post_path(@post), notice: 'This post was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to goal_posts_path(@goal), notice: 'This post was deleted.'
  end

  def post_params
    params.require(:post).permit(:title, :content, :goal_id)
  end

  protected

  def set_goal
    @goal ||= @post.goal
  end

end