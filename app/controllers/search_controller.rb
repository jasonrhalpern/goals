class SearchController < ApplicationController
  before_action :authenticate_user!, :only => []

  def index
    @goals = Goal.includes(:user).search(params[:search])
  end

end