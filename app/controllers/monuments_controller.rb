class MonumentsController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_monument, only: [:show, :edit, :update, :destroy, :coverflow]

  def index
    @monuments = current_user.monuments
  end

  def new
    @monument    = Monument.new
    @collections = current_user.collections
    @categories  = current_user.categories
  end

  def edit
    @collections = current_user.collections
    @categories  = current_user.categories
  end

  def show
    @picture = Picture.new
    @pictures = @monument.pictures
  end

  def create
    @monument = current_user.monuments.new(monument_params)

    if @monument.save
      redirect_to @monument, notice: 'Monument was successfully created.'
    else
      render :new
    end
  end

  def update
    if @monument.update(monument_params)
      redirect_to @monument, notice: 'Monument was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @monument.destroy
    redirect_to monuments_url, notice: 'Monument was successfully destroyed.'
  end

  def coverflow
    @pictures = @monument.pictures
  end

  private

  def set_monument
    @monument = current_user.monuments.find(params[:id])
  end

  def monument_params
    params.require(:monument).permit(:name, :description, :category_id, :collection_id)
  end
end
