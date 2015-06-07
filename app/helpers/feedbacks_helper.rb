#
# Various utilites for feedback pages
#
module FeedbacksHelper
  def leave_reference_link_for(from, to)
    feedback = from.sent_feedbacks.find_by(recipient: to)

    link_to link_destination(to, feedback) do
      content_tag(:div, class: 'icon-info') { image_tag 'feedback.png' } +
        content_tag(:div, class: 'content-info') { link_title(feedback) }
    end
  end

  private

  def link_destination(user, feedback)
    return new_user_feedback_path(user) unless feedback

    edit_user_feedback_path(user, feedback)
  end

  def link_title(feedback)
    feedback ? t('.edit_feedback') : t('.new_feedback')
  end
end
