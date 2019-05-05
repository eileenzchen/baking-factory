class OrderItemsController < ApplicationController
  include AppHelpers::Cart
  #before_action :check_login
  #authorize_resource

  def toggle_shipped
    @order_item = OrderItem.find(params[:id])
    if @order_item.shipped_on.nil?
      @order_item.update_attribute(:shipped_on, Date.current)
      flash[:notice] = "Order item marked as shipped."
    else
      @order_item.update_attribute(:shipped_on, nil)
      flash[:notice] = "Order item marked as unshipped."
    end
 
    redirect_back fallback_location: home_path
      

    end
    
  end

  def index
    @shipped = OrderItem.all.shipped.chronological.paginate(page: params[:page]).per_page(10)
    @unshipped = OrderItem.all.unshipped.paginate(page: params[:page]).per_page(10)
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
      redirect_to home_path
    end
  end

  def update
    if @order_item.update(order_item_params)
      if current_user.role?(:baker)
        redirect_to home_path, notice: "Your order item was updated in the system."
      else 
        redirect_to @order_item
      end
    else
      if current_user.role?(:baker)
        redirect_to home_path
      else
        render action: 'edit'
      end
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
      params.require(:order_item).permit(:order_id, :item_id, :quantity, :shipped_on)
    end

end