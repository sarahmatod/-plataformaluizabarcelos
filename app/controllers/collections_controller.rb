class CollectionsController < ApplicationController
  before_action :set_collection, only: %i[show edit update destroy]
  before_action do
    authorize(Collection)
  end

  # SHOW => RESULTS PAGES
  def show
    no_zero_votes = @collection.items.select do |item|
      item.votes.count >= 1
    end
    @items = no_zero_votes.sort_by { |item| item.votes.count }.reverse
  end

  def new
    @collections = Collection.all.order(created_at: :desc)
    @collection = Collection.new
  end

  def create
    active_false
    @collection = Collection.create(name: collection_params[:name], photo: collection_params[:photo], user: current_user, active: false)
    add_shoes_to_collection
    redirect_to edit_collection_path(@collection)
  end

  #desativando collection a medida que crio uma nova
  def active_false
    unless Collection.last == nil
    last_collection = Collection.last
    last_collection.active = false
    last_collection.save
    end
  end

  def available
    @collection = Collection.last
    @collection.active = true
    @collection.save

    redirect_to root_path
  end

  def getavailable
    available
  end

  def unavailable
    @collection = Collection.last
    @collection.active = false
    @collection.save

    redirect_to root_path
  end

  def getunavailable
    unavailable
  end


  def edit
    @collections = Collection.all.order(created_at: :desc)
    @items = Item.all.where(collection: @collection)
    @items = @items.sort_by { |item| item.name }
    @items = @items.uniq { |h| h[:name] }

    @items.each do |item|
      @item = item
    end

  end

  def update
    if collection_params[:photos]
      add_shoes_to_collection
    end
    if collection_params[:photo]
    @collection.update(collection_params)
    end
    redirect_to edit_collection_path(@collection)
  end

  def destroy
    if @collection.user_choices != []
      @collection.user_choices.each do |choice|
        choice.votes.each do |vote|
          vote.delete
        end
        choice.delete
      end
    end

    @collection.items.each do |item|
      item.delete
    end
    @collection.delete

    redirect_to new_collection_path
  end

  private

  def add_shoes_to_collection
    collection_params[:photos].each do |photo|
      Item.create(collection: @collection,
                  name: photo.original_filename,
                  photo: photo)
    end
  end

  def collection_params
    params.require(:collection).permit(:name, :photo, photos: [])
  end

  def set_collection
    @collection = Collection.find(params[:id])
  end

end
