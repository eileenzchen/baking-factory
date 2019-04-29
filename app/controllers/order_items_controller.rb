class OrderItemsController < ApplicationController
  include AppHelpers::Cart
  before_action :check_login
  authorize_resource
  
  def new
    @order_item = OrderItem.new
    @order = Order.find(params[:order_id])
    @item = Item.find(params[:item_id])
  end
  
  def create
    @order_item = OrderItem.new(order_item_params)
    if @order_item.save && add_item_to_cart(@order_item.item_id)
      flash[:notice] = "Successfully added #{@order_item.quantity} #{@item.name} to cart."
      redirect_to home_path
    else
      render action: 'new', locals: { visit: @visit, pet: @pet }
    end
  end
 
  def destroy
    @dosage = Dosage.find(params[:id])
    @dosage.destroy
    flash[:notice] = "Successfully removed this dosage."
    redirect_to visit_path(@dosage.visit)
  end

  private
    def order_item_params
      params.require(:dosage).permit(:order_id, :item_id, :quantity)
    end

end