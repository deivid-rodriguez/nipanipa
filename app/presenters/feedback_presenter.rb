# frozen_string_literal: true

require "concerns/date_formatable"

#
# Base presentation layer class for feebacks
#
class FeedbackPresenter < ApplicationPresenter
  include DateFormatable

  def side
    raise NotImplementedError, "Subclass responsability"
  end

  def link_me
    raise NotImplementedError, "Subclass responsability"
  end

  relative_time :updated_at

  private

  def labeled_link(preposition, author)
    preposition = I18n.t("feedbacks.feedback.#{preposition}")
    link = view.link_to author.name, author

    view.safe_join([preposition, link], " ")
  end
end
