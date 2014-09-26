class CollectionsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_collection, only: [:show, :edit, :update, :destroy]

  def index
    @collections = current_user.collections
  end

  def new
    @collection = Collection.new
  end

  def edit
  end

  def show
  end

  def create
    @collection = current_user.collections.new(collection_params)

    if @collection.save
      redirect_to collections_url, notice: 'Collection was successfully created.'
    else
      render :new
    end
  end

  def update
    if @collection.update(collection_params)
      redirect_to collections_url, notice: 'Collection was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @collection.destroy
    redirect_to collections_url, notice: 'Collection was successfully destroyed.'
  end

  private

  def set_collection
    @collection = current_user.collections.find(params[:id])
  end

  def collection_params
    params.require(:collection).permit(:name)
  end
end
