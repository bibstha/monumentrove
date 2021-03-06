class CategoriesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = current_user.categories
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def show
    @monuments = @category.monuments
  end

  def create
    @category = current_user.categories.new(category_params)

    if @category.save
      redirect_to categories_url, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_url, notice: 'Collection was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_url, notice: 'Collection was successfully destroyed.'
  end

  private

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

end
