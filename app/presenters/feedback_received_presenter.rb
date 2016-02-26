# frozen_string_literal: true

#
# Presentation layer for received feedbacks
#
class FeedbackReceivedPresenter < FeedbackPresenter
  def side
    'right'
  end

  def link_to_me
    labeled_link('from', sender)
  end
end
