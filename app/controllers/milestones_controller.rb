class MilestonesController < ApplicationController
  load_and_authorize_resource :goal
  load_and_authorize_resource :milestone, :through => :goal, :shallow => true
  before_filter :set_goal

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @milestones = @milestones.order(reach_by_date: :desc).page(params[:page]).per(10)
  end

  def new
  end

  def create
    if @milestone.save
      redirect_to goal_milestones_path(@goal), notice: 'This milestone was successfully saved.'
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @milestone.update_attributes(milestone_params)
      redirect_to milestone_path(@milestone), notice: 'This milestone was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @milestone.destroy
    redirect_to goal_milestones_path(@goal), notice: 'This milestone was deleted.'
  end

  def milestone_params
    params.require(:milestone).permit(:title, :description, :status, :reach_by_date, :goal_id)
  end

  protected

  def set_goal
    @goal ||= @milestone.goal
  end

end