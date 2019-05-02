class CustomersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :check_login, except: [:new, :create]
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  authorize_resource
  
  def index
    @active_customers = Customer.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_customers = Customer.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @previous_orders = @customer.orders.chronological
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
      puts @user.errors.inspect

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
    if @customer.destroy
    else
      @orders = @owner.orders.chronological.to_a
      render action: 'show'
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