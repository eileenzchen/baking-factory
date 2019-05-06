class ItemsController < ApplicationController
  include AppHelpers::Cart
  before_action :check_login, except: [:index, :show]
  before_action :set_item, only: [:show, :edit, :update, :destroy, :toggle]
  authorize_resource

  def toggle_item
    @item = Item.find(params[:id])
    if @item.active?
      @item.update_attribute(:active, false)
      flash[:notice] = "#{@item.name} was made inactive"
    else
      @item.update_attribute(:active, true)
      flash[:notice] = "#{@item.name} was made active"
    end
    
    redirect_back fallback_location: home_path
   
    
    
  end
  
  def index
    @all_items = Item.all.alphabetical.paginate(:page => params[:page]).per_page(10)
    @active_items = Item.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    # get info on active items for the big three...
    @bread = Item.active.for_category('bread').alphabetical.paginate(:page => params[:page]).per_page(10)
    @muffins = Item.active.for_category('muffins').alphabetical.paginate(:page => params[:page]).per_page(10)
    @pastries = Item.active.for_category('pastries').alphabetical.paginate(:page => params[:page]).per_page(10)
    # get a list of any inactive items for sidebar
    @inactive_items = Item.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)

  end

  def show
    if logged_in? && current_user.role?(:admin)
      # admin gets a price history in the sidebar
      @prices = @item.item_prices.chronological.to_a
    end
    # everyone sees similar items in the sidebar
    @similar_items = Item.for_category(@item.category).alphabetical.to_a
    if logged_in? && (current_user.role?(:admin) || current_user.role?(:customer))
      @num_items_in_cart = get_number_of_items
    end
  end

  def new_price
    @item_price = ItemPrice.new
    @item = Item.find(params[:id])
  end

  def create_price
    @item_price = ItemPrice.new(item_price_params)
    @item_price.start_date = Date.current
   
    if @item_price.save
      flash[:notice] = "Successfully updated item price."
      redirect_to @item
    else
      @item = Item.find(params[:item_price][:item_id])
      redirect_to new_price_path
    end
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to @item, notice: "#{@item.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: "#{@item.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    if @item.destroy
      redirect_to items_url, notice: "#{@item.name} was removed from the system."
    else
      redirect_back fallback_location: home_path, notice: "#{@item.name} cannot be removed from the system but was made inactive"
    end
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :picture, :category, :units_per_item, :weight, :active, :picture)
  end

  def item_price_params
    params.require(:item).permit(:item_id, :price)
  end

end