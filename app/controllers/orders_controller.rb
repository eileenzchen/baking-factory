class OrdersController < ApplicationController

  before_action :check_login
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  authorize_resource
  
  def index
    # get data on all orders or orders for particular owner and paginate the output to 10 per page
    if current_user.role?(:customer)
      @all_orders = current_user.customer.orders.chronological.paginate(page: params[:page]).per_page(10)
    else
      @all_orders = Order.all.chronological.paginate(page: params[:page]).per_page(10)
    end
  end

  def show
    @previous_orders = @order.customer.orders.chronological.to_a
  end

  def new
    @order = Order.new
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
    @order.date = Date.current
    if @order.save
      @order.pay
      redirect_to @order, notice: "Thank you for ordering from the Baking Factory."
    else
      render action: 'new'
    end
  end

  def update
    if @order.update(item_params)
      redirect_to @order, notice: "Your order was updated in the system."
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @order.destroy
    @cart = destroy_cart
    redirect_to orders_url, notice: "#{@order.name} was removed from the system."
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:address_id, :customer_id, :grand_total)
  end

end