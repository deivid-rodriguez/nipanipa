#
# Abilities/Roles through CanCanCan
#
# See the wiki for details:
# https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
#
# TODO: Remove CanCan and authorization from the app. We don't have any roles
# so this is overkill I think. If we added roles in the future, let's
# implement them through `pundit`.
#
class Ability
  include CanCan::Ability

  #
  # Define abilities for the passed in user here.
  #
  def initialize(user)
    # Even guest users can do a lot of stuff
    can :read, [User, Picture, Feedback]
    can :create, User
    return unless user

    can :manage, User, id: user.id
    can :manage, Picture, user_id: user.id
    can :manage, Feedback, sender_id: user.id
    can [:create, :read], Message, sender_id: user.id
    can :read, Message, recipient_id: user.id
  end
end
