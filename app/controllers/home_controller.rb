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
    @choc_zuke = Item.where("name LIKE ?", "%Chocolate Zucchini Muffins%").first
    if logged_in? && (current_user.role?(:admin) || current_user.role?(:customer))
      @num_items_in_cart = get_number_of_items
    end
     
    if logged_in? && (current_user.role?(:admin) || current_user.role?(:customer))
      @recent_order = Order.for_customer(current_user.customer.id).chronological.first
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
      @baking_list_bread = create_baking_list_for("bread")
      @baking_list_muffins = create_baking_list_for("muffins")
      @baking_list_pastries = create_baking_list_for("pastries")
    end
  end

  def about
    
  end

  def privacy
  end

  def contact
  end

  def search
    @query = params[:query]
    if current_user.nil? || current_user.role?(:customer)
      @items = Item.search(@query)
      @total_hits = @items.size
    elsif logged_in? && current_user.role?(:admin)
      @items = Item.search(@query)
      @customers = Customer.search(@query)
      @total_hits = @items.size + @customers.size
    end
    if logged_in? && (current_user.role?(:admin) || current_user.role?(:customer))
      @num_items_in_cart = get_number_of_items
    end
    
  end
end