class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource
  include AppHelpers::Cart 
  
  def index
    @all_users = User.all.alphabetical.paginate(page: params[:page]).per_page(15)
    @employees = User.employees.alphabetical.paginate(page: params[:page]).per_page(15)
    if logged_in? && current_user.role?(:admin) || current_user.role?(:customer)
      @num_items_in_cart = get_number_of_items
    end
  end

  def new
    @user = User.new
  end

  def edit
    @user.role = "admin" if current_user.role?(:admin)
  end

  def create
    @user = User.new(user_params)
    @user.role = "admin" if current_user.role?(:admin)
    if @user.save
      flash[:notice] = "Successfully added #{@user.proper_name} as a user."
      redirect_to users_url
    else
      render action: 'new'
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "Successfully updated #{@user.proper_name}."
      redirect_to users_url
    else
      render action: 'edit'
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_url, notice: "Successfully removed #{@user.proper_name} from the PATS system."
    
    else
      render action: 'show'
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :role, :password, :password_confirmation, :active )
    end

end
