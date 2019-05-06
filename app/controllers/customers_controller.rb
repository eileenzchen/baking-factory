class CustomersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include AppHelpers::Cart
  before_action :check_login, except: [:new, :create]
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def toggle_customer
    @customer = Customer.find(params[:id])
    if @customer.active?
      @customer.update_attribute(:active, false)
      flash[:notice] = "#{@customer.proper_name} made inactive."
    else
      @customer.update_attribute(:active, true)
      flash[:notice] = "#{@customer.proper_name} made active."
    end
    
    redirect_back fallback_location: home_path
   
    
    
  end
  
  def index
    @active_customers = Customer.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_customers = Customer.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
    if logged_in? && current_user.role?(:admin) || current_user.role?(:customer)
      @num_items_in_cart = get_number_of_items
    end
  end

  def show
    @previous_orders = @customer.orders.chronological
    if logged_in? && (current_user.role?(:admin) || current_user.role?(:customer))
      @num_items_in_cart = get_number_of_items
    end
  end

  def new
    @customer = Customer.new
  end

  def edit
    # reformat phone w/ dashes when displayed for editing (preference; not required)
    @customer.phone = number_to_phone(@customer.phone)
  end

  def create

    @customer = Customer.new(customer_params)
    @user = User.new
  
    @user.role = "customer"
    @user.active = "true"
    
    @user.username = @customer.username
    @user.password = @customer.password
    @user.password_confirmation = @customer.password_confirmation

    

    if !@user.save
      @customer.valid?
      render action: 'new'
    else
      @customer.user_id = @user.id
      if @customer.save
        flash[:notice] = "Successfully created #{@customer.proper_name}."
        redirect_to login_path
      
      else
        render action: 'new'
      end    
    end  
      
  end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "Successfully updated #{@customer.proper_name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    ## We don't allow destroy (will deactivate instead)
    if @owner.destroy
      # irrelevant now...
      # redirect_to owners_url, notice: "Successfully removed #{@owner.proper_name} from the PATS system."
    else
      # we still want this path with the base error message shown
      @previous_orders = @customer.orders.chronological.to_a
      render action: 'show', notice: "Cannot delete customer. #{@customer.proper_name} was made inactive."
    end

  end

  private
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :id, :active, :username, :password, :password_confirmation)
  end
end