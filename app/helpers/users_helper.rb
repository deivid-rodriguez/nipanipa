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

  def user_location user
    return t('.unknown') if user.country.blank?
    return user.country if user.state.blank?
    return "#{user.state}, #{user.country}"
  end

  def user_categories user
    return content_tag(:em, t('.unknown')) if user.work_types.empty?
    user.work_types.map{ |wt| t("work_types.#{wt.name}") }.join(', ')
  end

  def user_languages user
    return content_tag(:em, t('.unknown')) if user.language_skills.empty?
    user.language_skills.map{
      |ls| "#{ls.language.name} (#{ls.level.text})" }.join(', ')
  end

  def i18n_timeago timestamp
    t 'datetime.timestamp_ago', time: time_ago_in_words(timestamp)
  end
end
