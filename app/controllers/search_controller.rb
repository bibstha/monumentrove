class SearchController < ApplicationController

  before_action :authenticate_user!

  def search
    if params[:query].blank?
      @results = []
    else
      @results = Search.new(params[:query], current_user.id).results
    end
  end
end
