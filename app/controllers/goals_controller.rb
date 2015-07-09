class GoalsController < ApplicationController
  load_and_authorize_resource :user
  load_and_authorize_resource :goal, :through => :user, :shallow => true

  before_action :authenticate_user!

  def index
    @goals = @goals.order(created_at: :desc)
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
    params.require(:goal).permit(:title, :description, :visibility, :status, :user_id)
  end

end