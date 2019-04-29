class SessionsController < ApplicationController
  include AppHelpers::Cart
  def new

  end
  
  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to home_path, notice: "Logged in!"
      if current_user.role?(:customer) || current_user.role?(:admin)
        @cart = create_cart
        @cart_items = get_list_of_items_in_cart
      end
    else
      flash.now.alert = "Username and/or password is invalid"
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to home_path, notice: "Logged out!"
  end
end