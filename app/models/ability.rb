class Ability
  include CanCan::Ability

  # Define abilities for the passed in user here.
  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # everyone can read
    can :read, User
    can :read, Picture
    can :read, Feedback

    if user.role == 'admin'
      can :manage, :all
    elsif user.role == 'non-admin'
      can :manage, User,     id: user.id
      can :manage, Picture,  user_id: user.id
      can :manage, Feedback, sender: user
      cannot :manage, Feedback, recipient: user
    end

    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
