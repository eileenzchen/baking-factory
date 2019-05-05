class ItemPricesController < ApplicationController
  before_action :check_login
  authorize_resource
  
  def new
    @item_price = ItemPrice.new
    @item = Item.find(params[:item_id])
  end
  
  def create
    @item_price = ItemPrice.new(item_price_params)
    @item_price.start_date = Date.current
    
    if @item_price.save
      flash[:notice] = "Successfully updated item price."
      redirect_to item_path(@item_price.item)
    else
      @item = Item.find(params[:item_price][:item_id])
      render action: 'new'
    end
  end

  # def show
  #   @previous_prices = @item.item_prices.chronological.to_a
  #   if logged_in? && (current_user.role?(:admin) || current_user.role?(:customer))
  #     @num_items_in_cart = get_number_of_items
  #   end
  # end

  private
    def item_price_params
      params.require(:item_price).permit(:item_id, :price)
    end

end