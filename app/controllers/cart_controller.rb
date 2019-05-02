class HomeController < ApplicationController
  include AppHelpers::Cart
  include AppHelpers::Shipping
  before_action :check_login
  authorize_resource

  def cart

  end

  def checkout
    
  end



end