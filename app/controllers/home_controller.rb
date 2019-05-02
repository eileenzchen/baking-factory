class HomeController < ApplicationController
  include AppHelpers::Baking
  before_action :check_login

  def home
    #customers
    @active_items = Item.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    # get info on active items for the big three...
    @bread = Item.active.for_category('bread').alphabetical.paginate(:page => params[:page]).per_page(10)
    @muffins = Item.active.for_category('muffins').alphabetical.paginate(:page => params[:page]).per_page(10)
    @pastries = Item.active.for_category('pastries').alphabetical.paginate(:page => params[:page]).per_page(10)
    # get a list of any inactive items for sidebar
    if logged_in? && current_user.role?(:admin)
      @inactive_items = Item.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
    end

    #shippers
    if logged_in? && current_user.role?(:admin)
      @shipped = OrderItem.all.shipped.chronological.paginate(page: params[:page]).per_page(10)
      @unshipped = OrderItem.all.paginate(page: params[:page]).per_page(10)
    end

  end

  def about
  end

  def privacy
  end

  def contact
  end

end