class CartController < ApplicationController
  include AppHelpers::Cart
  include AppHelpers::Shipping
  before_action :check_login
  authorize_resource

  def add_item
    add_item_to_cart(params[:id])
    redirect_to home_path
  end

  def remove_item
    remove_item_from_cart(params[:id])
    redirect_to cart_path
  end

  def empty_cart
    clear_cart
  end

  def cart
    @items_in_cart = get_list_of_items_in_cart
    @subtotal = calculate_cart_items_cost
    @shipping_cost = calculate_cart_shipping
  end

  def checkout
    
  end




end