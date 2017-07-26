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
    if current_user.nil?
      redirect_to sign_in_path
    end
  end

  def require_edit_privileges
    if !current_user.can_edit?
      flash[:error] = "You don't have edit privileges."
      redirect_to songs_path
    end
  end

  def require_delete_privileges
    if !current_user.can_delete?
      flash[:error] = "You don't have deleting privileges."
      redirect_to songs_path
    end
  end

  # @praise_set needs to be set before calling this method
  def require_praise_set_permission
    if @praise_set.owner != current_user
      flash[:error] = "You dont have permission to see this praise set"
      redirect_to praise_sets_path
    end
  end
end
