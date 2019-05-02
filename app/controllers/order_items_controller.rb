class OrderItemsController < ApplicationController
  include AppHelpers::Cart
  before_action :check_login
  authorize_resource

  def index
    @shipped = OrderItem.all.shipped.chronological.paginate(page: params[:page]).per_page(10)
    @unshipped = OrderItem.all.paginate(page: params[:page]).per_page(10)
   
  end
  
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
      render action: 'new', locals: { order: @order, item: @item }
    end
  end
 
  def destroy
    @order_item = OrderItem.find(params[:id])
    if @order_item.destroy
      flash[:notice] = "Successfully removed this order item."
      redirect_to order_path(@order_item.order)
    else
      render action: 'show'
    end
    
    
  end

  private
    def order_item_params
      params.require(:dosage).permit(:order_id, :item_id, :quantity)
    end

end