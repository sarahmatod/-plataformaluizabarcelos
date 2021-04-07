class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

def new
  @item = Item.new()
end

def show
  @collection = @item.collection
  redirect_to edit_collection_path(@collection)
end

def index
  @items = Item.all
end

def destroy
  @collection = @item.collection
  @item.delete
  redirect_to edit_collection_path(@collection)

  authorize @item
end

def item_params
    params.require(:item).permit(:name, :photo)
  end

  def set_item
    @item = Item.find(params[:id])
  end

end
