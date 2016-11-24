class User
  attr_reader :email, :name
  def initialize(email, name)
    @email = email
    @name = name || "Guest"
  end

  def guest?
    @email.nil?
  end

  def signed_in?
    !guest?
  end
end
