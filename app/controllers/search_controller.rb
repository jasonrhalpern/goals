class SearchController < ApplicationController
  before_action :authenticate_user!, :only => []

  def index
    @goals = Goal.includes(:user).viewable.search(params[:search]).page(params[:page]).per(20)
  end

end