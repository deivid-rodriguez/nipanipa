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
end
