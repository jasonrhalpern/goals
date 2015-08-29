class GoalsController < ApplicationController
  load_and_authorize_resource :user
  load_and_authorize_resource :goal, :through => :user, :shallow => true
  before_filter :set_user
  skip_authorize_resource :user, :only => :index

  before_action :authenticate_user!, :except => [:index, :show]
  before_action :remove_blank_tags, :only => [:create]

  def index
    @goals = @goals.order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
  end

  def create
    if @goal.save
      redirect_to user_goals_path(@user), notice: 'This goal was successfully saved.'
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @goal.update_attributes(goal_params)
      redirect_to user_goals_path(@user), notice: 'This goal was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @goal.destroy
    redirect_to user_goals_path(@user), notice: 'This goal was deleted.'
  end

  def goal_params
    params.require(:goal).permit(:title, :description, :visibility, :status, :user_id, :tag_ids => [])
  end

  protected

  def set_user
    @user ||= @goal.user
  end

  def remove_blank_tags
    params[:goal][:tag_ids].reject!(&:blank?) if params[:goal][:tag_ids].present?
  end

end