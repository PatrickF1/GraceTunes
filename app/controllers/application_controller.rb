class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_sign_in

  helper_method :current_user

  # Return a user constructed from the fields stored in the session, nil if one cannot be constructed
  def current_user
    return @current_user if @current_user

    if [:user_email, :name, :role].all? { |field| session.key?(field) }
      @current_user = User.new(email: session[:user_email], name: session[:name], role: session[:role])
    end
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
