class SessionsController < ApplicationController

  skip_before_action :require_sign_in, except: :destroy

  def new
    redirect_to root_path if current_user.signed_in?
    @no_header = true
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    email = auth_hash["info"]["email"]
    full_name = auth_hash["info"]["name"]

    if !@current_user = User.find_by_name(username)
      @current_user = User.create(email: email, name: full_name)
    end

    session[:user_email] = email
    session[:user_name] = full_name.split.first # only save the first name
    redirect_to root_url
  end

  def destroy
    session.delete(:user_email)
    session.delete(:user_name)
    redirect_to sign_in_path
  end

  def error
    case params[:message]
    when 'invalid_credentials'
      flash[:error] = "Invalid credentials: you must sign in with a Gpmail account."
    when 'access_denied'
      flash[:error] = "Access to the account was denied."
    else
      flash[:error] = "Something went wrong while authenticating. Please try again."
    end
    redirect_to sign_in_path
  end
end
