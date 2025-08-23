# frozen_string_literal: true

class API::APIController < ActionController::API
  before_action :require_sign_in

  DEFAULT_PAGE_SIZE = 100

  def require_sign_in
    head :forbidden if current_user.nil?
  end

  def require_edit_privileges
    head :forbidden unless current_user.can_edit?
  end

  def require_delete_privileges
    head :forbidden unless current_user.can_delete?
  end

  def current_user
    return @current_user if @current_user

    # Prefer Authorization: Bearer <firebase_id_token> when provided
    bearer_user = current_user_from_bearer
    return @current_user = bearer_user if bearer_user

    # Fallback to session-based auth (used by web app)
    return unless [:user_email, :name, :role].all? { |field| session.key?(field) }

    @current_user = User.new(email: session[:user_email], name: session[:name], role: session[:role])
  end

  def render_form_errors(message, errors)
    render json: {message:, errors:}, status: :bad_request
  end

  def render_paginated_result(data, matching_count, total_count)
    render json: {data:, matching_count:, total_count:}
  end

  private

  def current_user_from_bearer
    token = bearer_token
    return nil unless token

    begin
      # Certificates are cached by the gem; ensure they are available
      FirebaseIdToken::Certificates.request
      payload = FirebaseIdToken::Signature.verify(token)
    rescue StandardError
      payload = nil
    end

    return nil unless payload

    # Only accept verified emails
    email = payload["email"]&.downcase
    name = payload["name"] || email
    email_verified = payload["email_verified"] == true
    return nil if email.nil? || !email_verified

    # If a persisted user exists, use their role; otherwise default to Reader
    persisted = User.find_by(email: email)
    role = persisted&.role || Role::READER

    User.new(email:, name:, role:)
  end

  def bearer_token
    header = request.headers["Authorization"]
    return nil unless header&.start_with?("Bearer ")
    header.split(" ", 2).last
  end
end
