class SessionsController < ApplicationController

  skip_before_action :require_sign_in

  def new
    redirect_to songs_path if current_user
    @no_header = true
  end

  def create
    user_info = request.env["omniauth.auth"]["info"]
    # Gmail emails are case insensitive so okay to lowercase it
    email = user_info["email"].downcase.strip
    # Temporary hack to make new domain emails map to old user roles
    email = email.gsub('acts2.network', 'gpmail.org')

    # if person has never signed into GraceTunes before, create a user for him
    unless (@current_user = User.find_by_email(email))
      full_name = user_info["name"].split('(')[0].strip # remove churchplant extention
      @current_user = User.create(email: email, name: full_name, role: Role::READER)
      logger.info "New user created: #{@current_user}"
    end

    session[:user_email] = @current_user.email
    session[:name] = @current_user.name
    session[:role] = @current_user.role
    redirect_to songs_path
  end

  def destroy
    session.delete(:user_email)
    redirect_to sign_in_path
  end

  def error
    logger.info "Error authenticating user: #{params[:message]}"
    case params[:message]
    when 'invalid_credentials'
      flash[:error] = "Invalid credentials: you must sign in with a Acts2Network account."
    when 'access_denied'
      flash[:error] = "Access to the account was denied."
    else
      flash[:error] = "Something went wrong while authenticating. Please try again."
    end
    redirect_to sign_in_path
  end
end
