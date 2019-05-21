class SessionsController < ApplicationController
  include AppHelpers::Cart
  def new

  end
  
  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      if logged_in? && current_user.role?(:customer) || current_user.role?(:admin)
        create_cart
      end
      flash[:notice] = "Logged in!"
      redirect_to home_path
      
      
    else
      flash.now.alert = "Username and/or password is invalid"
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    destroy_cart
    flash[:notice] = "Logged out!"
    redirect_to home_path
    
    
  end

  
end