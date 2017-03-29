class SessionsController < ApplicationController

  skip_before_action :require_sign_in, except: :destroy

  def new
    redirect_to root_path if @current_user.nil?
    @no_header = true
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    email = auth_hash["info"]["email"].strip

    # person has never signed into GraceTunes before so create a user for him
    if !@current_user = User.find_by_email(email)
      full_name = auth_hash["info"]["name"].split('(')[0].strip # remove churchplant extention
      @current_user = User.create(email: email, name: full_name, role: Role::READER)
    end

    session[:user_email] = {
      value: @current_user.email,
      :expires => 1.week.from_now
    }
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
