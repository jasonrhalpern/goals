class SearchController < ApplicationController
  before_action :authenticate_user!, :only => []

  def index

  end

end