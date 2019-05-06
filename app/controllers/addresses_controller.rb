class AddressesController < ApplicationController
  include AppHelpers::Cart
  before_action :check_login
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  authorize_resource
  
  def index
    # get data on all addresses or addresses for a particular customer and paginate the output to 10 per page
    if current_user.role?(:customer)
      @active_addresses = current_user.customer.addresses.active.by_recipient.paginate(page: params[:page]).per_page(10)
      @inactive_addresses = current_user.customer.addresses.inactive.by_recipient.paginate(page: params[:page]).per_page(10)
    else
      @active_addresses = Address.active.by_customer.by_recipient.paginate(:page => params[:page]).per_page(10)
      @inactive_addresses = Address.inactive.by_customer.by_recipient.paginate(:page => params[:page]).per_page(10)
    end
    if logged_in? && current_user.role?(:admin) || current_user.role?(:customer)
      @num_items_in_cart = get_number_of_items
    end

  end

  def show
  end

  def new
    @address = Address.new
    if logged_in? && (current_user.role?(:admin) || current_user.role?(:customer))
      @num_items_in_cart = get_number_of_items
    end
  end

  def edit
  end

  def create
    if logged_in? && (current_user.role?(:admin) || current_user.role?(:customer))
      @num_items_in_cart = get_number_of_items
    end
    @address = Address.new(address_params)
    if @address.customer_id.nil?
      @address.customer_id = current_user.customer.id
    end
    if @address.save
      if current_user.role?(:admin)
        redirect_to customer_path(@address.customer), notice: "The address was added to #{@address.customer.proper_name}."
      elsif current_user.role?(:customer)
        
        redirect_to checkout_path
      end
    else
      render action: 'new'
    end
  end

  def update
    if @address.update(address_params)
      redirect_to addresses_path, notice: "The address was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @address = Address.find(params[:id])
    if @address.destroy
      flash[:notice] = "Successfully deleted address."
      redirect_to addresses_path
    else
      flash[:notice] = "Cannot delete address as it has been used. Address was made inactive."
      redirect_to addresses_path
    end
    
    
  end


  private
  def set_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:customer_id, :recipient, :street_1, :street_2, :city, :state, :zip, :active, :is_billing, :customer_id)
  end

end