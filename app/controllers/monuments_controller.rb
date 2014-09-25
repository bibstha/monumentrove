class MonumentsController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_monument, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @monument = Monument.new
    @collections = current_user.collections
    @categories = current_user.categories
  end

  def edit
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def set_monument
    @monument = current_user.monuments.find(params[:id])
  end

  def monument_params
  end
end
