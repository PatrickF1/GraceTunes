class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_sign_in

  helper_method :current_user

  def current_user
    # TODO actually implement
    @current_user ||= User.new(
      email: "test@email.com",
      name: "GraceTunes Test",
      role: Role::ADMIN
    )
  end

  def require_sign_in
    if current_user.nil?
      redirect_to sign_in_path
    end
  end
end
