# frozen_string_literal: true

#
# ActiveAdmin authorization rules
#
class OnlyAdminsAuthorizationAdapter < ActiveAdmin::AuthorizationAdapter
  def authorized?(_action, _subject = nil)
    user.admin_at?
  end
end
