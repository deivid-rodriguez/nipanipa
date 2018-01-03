# frozen_string_literal: true

#
# Various utilites for feedback pages
#
module FeedbacksHelper
  def feedback_count(feedbacks)
    received_count = feedbacks.count { |f| f[0] }
    sent_count = feedbacks.count { |f| f[1] }
    count_str = t("users.show.feedback")

    if received_count.nonzero? || sent_count.nonzero?
      received = t("feedbacks.received", count: received_count)
      sent = t("feedbacks.sent", count: sent_count)
      count_str += " (#{received}, #{sent})"
    end

    count_str
  end
end
