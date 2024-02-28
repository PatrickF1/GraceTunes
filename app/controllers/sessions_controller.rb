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
    full_name = user_info["name"].split('(')[0].strip # remove church plant city extension

    @current_user = User.find_by(email:)
    if @current_user.nil?
      # this person has never signed in before, create a user for them
      @current_user = User.create!(email:, name: full_name, role: Role::READER)
      logger.info "New user created: #{@current_user}"
    elsif @current_user.name != full_name
      # their name according to Tribe has updated
      @current_user.name = full_name
      logger.error "Unable to update the name for #{@current_user}" unless @current_user.save
    end

    session[:user_email] = @current_user.email
    session[:name] = @current_user.name
    session[:role] = @current_user.role
    redirect_to songs_path
  end

  def destroy
    reset_session
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
