class Ability
  include CanCan::Ability

  def initialize(user)
    # Everyone: RUD themselves
    can [:read, :update, :destroy], ::User do |subject|
      subject.id == user.id
    end

    case user.role
    when Role::ADMIN
      # Admins: CRUD anything
      can :manage, :all
    when Role::PRAISE
      # Praise members: CRU songs
      can [:create, :read, :update], ::Song
    when Role::READER
      # Readers: R songs
      can :read, ::Song
    end
  end
end
