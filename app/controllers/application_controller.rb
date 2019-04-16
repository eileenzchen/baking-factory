class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # show a flash message instead of full CanCan exception
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You are not authorized to perform this action."
    redirect_to home_path
  end

end
