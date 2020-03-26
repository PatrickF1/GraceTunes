module API
  module V2
    class AuthenticationError < StandardError
    end

    class APIController < ActionController::API
      include CanCan::ControllerAdditions

      # Enforce authentication for every request
      before_action :authn_check

      # Enforce authorization for every request
      load_and_authorize_resource

      def initialize
        @google_id_token_validator = GoogleIDToken::Validator.new
      end

      def current_user
        @current_user
      end

      # Authentication consists checking the Authorization header for a JWT bearer token, and cryptographically verifying
      # that the token:
      # 1. was issued, signed by Google's OAuth2 service
      # 2. has not expired
      # 3. was issued for the appropriate audience (our app's Google OAuth2 client ID)
      # 4. was issued for a user within the appropriate hosted domain (gpmail.org)
      def authn_check
        begin
          auth_header = request.headers['Authorization']

          if auth_header == nil?
            raise RuntimeError, 'Missing Authorization header'
          end

          type, token = auth_header.split(' ')

          if type != 'Bearer' || token.nil?
            raise RuntimeError, 'Authorization header missing bearer token'
          end

          payload = @google_id_token_validator.check(token, ENV.fetch('GOOGLE_CLIENT_ID'))

          name = payload.fetch('name')
          email = payload.fetch('email')
          hd = payload.fetch('hd')

          if hd != 'gpmail.org'
            raise RuntimeError, "Invalid hosted domain: #{hd}"
          end

          @current_user = User.find_by_email(email) || User.create(email: email, name: name, role: Role::READER)
        rescue Exception => e
          raise AuthenticationError, e.message
        end
      end

      # 404
      rescue_from ActiveRecord::RecordNotFound do |e|
        render json: {error: 'Not found'}, status: :not_found
      end

      # 401
      rescue_from AuthenticationError do |e|
        render json: {error: e.message}, status: :unauthorized
      end

      # 403
      rescue_from CanCan::AccessDenied do |e|
        render json: {error: e.message}, status: :forbidden
      end

      # 400
      rescue_from ActiveModel::ForbiddenAttributesError, ActiveRecord::RecordInvalid do |e|
        render json: {error: e.message}, status: :bad_request
      end
    end
  end
end


