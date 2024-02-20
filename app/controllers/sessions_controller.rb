# frozen_string_literal: true

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

    # if person has never signed into GraceTunes before, create a user for him
    unless (@current_user = User.find_by(email:))
      @current_user = User.create!(email:, role: Role::READER)
      logger.info "New user created: #{@current_user}"
    end
    full_name = user_info["name"].split('(')[0].strip # remove churchplant extention

    session[:user_email] = @current_user.email
    session[:name] = full_name
    session[:role] = @current_user.role
    redirect_to songs_path
  end

  def destroy
    session.delete(:user_email)
    redirect_to sign_in_path
  end

  def error
    logger.info "Error authenticating user: #{params[:message]}"
    flash[:error] = case params[:message]
                    when 'invalid_credentials'
                      "Invalid credentials: you must sign in with a Acts2Network account."
                    when 'access_denied'
                      "Access to the account was denied."
                    else
                      "Something went wrong while authenticating. Please try again."
                    end
    redirect_to sign_in_path
  end
end
