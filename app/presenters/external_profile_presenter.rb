# frozen_string_literal: true

require "concerns/profilable"

#
# Presentation layer for external profiles (not the current user's one)
#
class ExternalProfilePresenter < ApplicationPresenter
  include Profilable

  attr_accessor :current_user

  def initialize(user, current_user, view)
    super(user, view)

    @current_user = current_user
  end

  def actions
    [new_message_action, new_feedback_action]
  end

  private

  def new_message_action
    {
      # i18n-tasks-use t("shared.profile_header.new_message")
      name: tab_name("new_message"),
      dest: view.conversation_path(self),
      class: "envelope"
    }
  end

  def new_feedback_action
    {
      # i18n-tasks-use t('shared.profile_header.new_feedback')
      name: tab_name("new_feedback"),
      dest: feedback_destination(current_user, self),
      class: "ok"
    }
  end

  def feedback_destination(from, to)
    return view.new_user_feedback_path(to) unless from

    feedback = from.sent_feedbacks.find_by(recipient: to)
    return view.new_user_feedback_path(to) unless feedback

    view.edit_user_feedback_path(to, feedback)
  end
end
