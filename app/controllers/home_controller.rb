class HomeController < ApplicationController
  include AppHelpers::Cart
  include AppHelpers::Baking

  def home
    #customers
    @active_items = Item.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @all_items = Item.all.alphabetical.paginate(:page => params[:page]).per_page(10)
    # get info on active items for the big three...
    @bread = Item.active.for_category('bread').alphabetical.paginate(:page => params[:page]).per_page(10)
    @muffins = Item.active.for_category('muffins').alphabetical.paginate(:page => params[:page]).per_page(10)
    @pastries = Item.active.for_category('pastries').alphabetical.paginate(:page => params[:page]).per_page(10)
    if logged_in? && (current_user.role?(:admin) || current_user.role?(:customer))
      @num_items_in_cart = get_number_of_items
    end
    # get a list of any inactive items for sidebar
    if logged_in? && current_user.role?(:admin)
      @inactive_items = Item.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
    end

    #shippers
    if logged_in? && (current_user.role?(:shipper) || current_user.role?(:admin))
      @shipped = OrderItem.all.shipped.chronological.paginate(page: params[:page]).per_page(10)
      @unshipped = OrderItem.all.unshipped.paginate(page: params[:page]).per_page(10)
    end

    #bakers
    if logged_in? && (current_user.role?(:baker) || current_user.role?(:admin))
      @baking_list_bread = create_baking_list_for("Bread")
      @baking_list_muffins = create_baking_list_for("Muffins")
      @baking_list_pastries = create_baking_list_for("Pastries")
    end
  end

  def about
    
  end

  def privacy
  end

  def contact
  end

end