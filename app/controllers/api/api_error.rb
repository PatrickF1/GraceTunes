class API::APIError
  def initialize(message, validation_errors)
    @message = message
    @validation_errors = validation_errors
  end
end