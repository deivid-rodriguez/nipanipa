# frozen_string_literal: true

#
# Base presentation layer class for feebacks
#
class FeedbackPresenter < SimpleDelegator
  attr_reader :view

  def initialize(feedback, view)
    super(feedback)

    @view = view
  end

  def side
    raise NotImplementedError, 'Subclass responsability'
  end

  def link_me
    raise NotImplementedError, 'Subclass responsability'
  end

  private

  def labeled_link(preposition, author)
    preposition_i18n = I18n.t("feedbacks.feedback.#{preposition}")
    link = view.link_to author.name, author

    "#{preposition_i18n} #{link}".html_safe
  end
end
