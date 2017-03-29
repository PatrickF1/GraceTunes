class SessionsController < ApplicationController

  skip_before_action :require_sign_in, except: :destroy

  def new
    redirect_to root_path if current_user
    @no_header = true
  end

  def create
    user_info = request.env["omniauth.auth"]["info"]
    # Gmail emails are case insensitive so okay to lowercase it
    email = user_info["email"].downcase.strip

    # if person has never signed into GraceTunes before, create a user for him
    if !@current_user = User.find_by_email(email)
      full_name = user_info["name"].split('(')[0].strip # remove churchplant extention
      @current_user = User.create(email: email, name: full_name, role: Role::READER)
    end

    session[:user_email] = @current_user.email
    redirect_to root_url
  end

  def destroy
    session.delete(:user_email)
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
