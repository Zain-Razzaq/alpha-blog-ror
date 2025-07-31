class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :user_logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_logged_in?
      current_user.present?
  end

  def authenticate_user!
    return if user_logged_in?
    flash[:alert] = "You must be logged in to access this section."
    redirect_to login_path
  end
end
