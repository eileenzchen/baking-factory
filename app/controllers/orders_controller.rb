class OrdersController < ApplicationController
  include AppHelpers::Cart
  include AppHelpers::Shipping
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
    if logged_in? && current_user.role?(:admin) || current_user.role?(:customer)
      @num_items_in_cart = get_number_of_items
    end
  end

  def show
    @previous_orders = @order.customer.orders.chronological.to_a
    if logged_in? && current_user.role?(:admin) || current_user.role?(:customer)
      @num_items_in_cart = get_number_of_items
    end
  end

  def new
    @order = Order.new
  end

  def edit
  end

  def create
    @order = Order.new(order_params)

    @order.date = Date.current
    subtotal = calculate_cart_items_cost
    shipping_cost = calculate_cart_shipping 

    if @order.customer_id.nil?
      @order.customer_id = current_user.customer.id
    end
    @order.grand_total = subtotal + shipping_cost

    
  
    
    if @order.save
      save_each_item_in_cart(@order)
      @order.pay
      clear_cart
      if current_user.role?(:customer)
        redirect_to home_path, notice: "Thank you for ordering from the Baking Factory."
      else
        redirect_to @order, notice: "Thank you for ordering from the Baking Factory."
      end
    else
      puts "&*&*&**&**&&**&"
      puts @order.errors.to_a
      if current_user.role?(:admin)
        render action: 'new'
      else
        redirect_to checkout_path
      end

    end
  end

  def update
    if @order.update(order_params)
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
    params.require(:order).permit(:address_id, :customer_id, :credit_card_number, :expiration_year, :expiration_month)
  end

end