class API::APIController < ActionController::API
  include ActionController::RequestForgeryProtection
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :null_session

  # before_action :require_sign_in

  def require_sign_in
    head :forbidden if @current_user.nil?
  end

  def current_user
    return @current_user if @current_user

    if [:user_email, :name, :role].all? { |field| session.key?(field) }
      @current_user = User.new(email: session[:user_email], name: session[:name], role: session[:role])
    end
  end

end
