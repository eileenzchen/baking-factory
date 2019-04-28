class ItemPricesController < ApplicationController
  before_action :check_login
  authorize_resource
  
  def new
    @item_price = ItemPrice.new
    @item = Item.find(params[:item_id])
  end
  
  def create
    @ItemPrice = ItemPrice.new(item_price_params)
    @item_price.start_date = Date.current
   
    if @item_price.save
      flash[:notice] = "Successfully updated item price."
      redirect_to item_path(@item_price.medicine)
    else
      @item = Item.find(params[:item_price][:item_id])
      render action: 'new', locals: { medicine: @item }
    end
  end

  private
    def item_price_params
      params.require(:item_price).permit(:item_id, :price)
    end

end