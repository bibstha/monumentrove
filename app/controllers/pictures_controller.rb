class PicturesController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_monument_and_picture, only: [:edit, :update, :destroy]

  def show
  end

  def edit
  end

  def create
    @picture  = current_monument.pictures.new(picture_new_params)
    if @picture.save
      redirect_to current_monument, notice: "Picture was successfully created."
    else
      render :new
    end
  end

  def update
    if @picture.update(picture_edit_params)
      redirect_to @monument, notice: 'Picture was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @picture.destroy
    redirect_to @monument, notice: 'Picture was successfully destroyed.'
  end


  private
  def set_monument_and_picture
    @monument = current_monument
    @picture  = @monument.pictures.find(params[:id])
  end

  def picture_new_params
    params.require(:picture).permit(:name, :description, :date, :image)
  end

  def picture_edit_params
    params.require(:picture).permit(:name, :description, :date)
  end

  def current_monument
    @current_monument ||= current_user.monuments.find(params[:monument_id])
  end
  
end
