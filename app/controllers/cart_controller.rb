class CartController < ApplicationController

  include AppHelpers::Cart

  include AppHelpers::Shipping
  before_action :check_login
  #authorize_resource

  def add_item
    add_item_to_cart(params[:id])
    @item = Item.find(params[:id])
    redirect_to home_path
    flash[:notice] = "#{@item.name} was added to cart."
  end

  def remove_item
    @item = Item.find(params[:id])
    remove_item_from_cart(params[:id])
    redirect_to view_cart_path
  end

  def empty_cart
    clear_cart
    flash[:notice] = "Cart is emptied."
    redirect_to view_cart_path
  end

  # def update_quantity
  #   @order_item = OrderItem.find(params[:id])
  #   update_quantity(@order_item)
  #   #redirect_to view_cart_path

  # end

  def show
    #options: continue shopping, checkout (order/new), empty cart (link to empty_cart)
    @items_in_cart = get_list_of_items_in_cart
    @subtotal = calculate_cart_items_cost
    @shipping_cost = calculate_cart_shipping
    @total = @subtotal + @shipping_cost
    @num_items_in_cart = get_number_of_items
  end

  def checkout
    @order = Order.new
    @num_items_in_cart = get_number_of_items
    @user = User.find(params[:id])
    @customer = Customer.find(params[:id])
    
    @addresses = get_address_options(@user)
  end




end