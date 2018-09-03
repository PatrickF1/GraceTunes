class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_sign_in

  helper_method :current_user

  # returns the current user if signed in or nil if not signed in
  def current_user
    return nil if session[:user_email].nil?
    @current_user ||= User.find_by_email(session[:user_email])
  end

  def require_sign_in
    redirect_to sign_in_path if current_user.nil?
  end

  def require_edit_privileges
    return if current_user.can_edit?

    flash[:error] = "You don't have edit privileges."
    redirect_to songs_path
  end

  def require_delete_privileges
    return if current_user.can_delete?
    flash[:error] = "You don't have deleting privileges."
    redirect_to songs_path
  end
end
