module UsersHelper

  def avatar_for user, options = { style: :small_cropped }
    range = karma_to_type(user.karma)
    url = "#{user.type.underscore}#{range}_#{options[:style]}.png"
    alt = "#{user.type} avatar"
    image_tag url, alt: alt
  end

  def karma_to_type karma
    return 1 if karma < 0
    return 2 if karma == 0
    return 3 if karma == 1
    return 4 if karma >= 2 && karma < 10
    return 5
  end

  def feedback_count feedbacks
    received_count = feedbacks.count { |f| !!f[0] }
    sent_count     = feedbacks.count { |f| !!f[1] }
    count_str = "#{t 'feedbacks.feedbacks.title'}"
    if received_count != 0 || sent_count != 0
      count_str += " (%s, %s)" % [
        t('feedbacks.received', count: received_count),
        t('feedbacks.sent', count: sent_count)
      ]
    end
    return count_str
  end

end
