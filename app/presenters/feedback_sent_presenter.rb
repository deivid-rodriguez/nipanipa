# frozen_string_literal: true

#
# Presentation layer for sent feedbacks
#
class FeedbackSentPresenter < FeedbackPresenter
  def side
    'left'
  end

  def link_to_me
    labeled_link('to', recipient)
  end
end
