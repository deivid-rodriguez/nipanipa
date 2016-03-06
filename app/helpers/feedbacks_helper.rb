# frozen_string_literal: true

#
# Various utilites for feedback pages
#
module FeedbacksHelper
  def feedback_destination(from, to)
    return new_user_feedback_path(to) unless from

    feedback = from.sent_feedbacks.find_by(recipient: to)
    return new_user_feedback_path(to) unless feedback

    edit_user_feedback_path(to, feedback)
  end

  def feedback_count(feedbacks)
    received_count = feedbacks.count { |f| f[0] }
    sent_count = feedbacks.count { |f| f[1] }
    count_str = t("users.show.feedback")

    if received_count != 0 || sent_count != 0
      received = t("feedbacks.received", count: received_count)
      sent = t("feedbacks.sent", count: sent_count)
      count_str += format(" (%s, %s)", received, sent)
    end

    count_str
  end
end
