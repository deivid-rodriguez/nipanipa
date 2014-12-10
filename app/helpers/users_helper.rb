#
# Various utilites for user pages
#
module UsersHelper
  def avatar_for(user, options = { style: :small })
    range = karma_to_type(user.karma)
    url = "#{user.type.underscore}#{range}_#{options[:style]}.png"
    alt = "#{user.type} avatar"
    image_tag(url, alt: alt)
  end

  def avatar_link_for(user, options = { style: :small })
    link_to avatar_for(user, options), user
  end

  def karma_to_type(karma)
    return 1 if karma < 0
    return 2 if karma == 0
    return 3 if karma == 1
    return 4 if karma >= 2 && karma < 10
    5
  end

  def feedback_count(feedbacks)
    received_count = feedbacks.count { |f| !f[0].nil? }
    sent_count = feedbacks.count { |f| !f[1].nil? }
    count_str = "#{t 'feedbacks.feedbacks.title'}"
    if received_count != 0 || sent_count != 0
      received = t('feedbacks.received', count: received_count)
      sent = t('feedbacks.sent', count: sent_count)
      count_str += format(' (%s, %s)', received, sent)
    end
    count_str
  end

  def user_location(user)
    return t('.unknown') if user.region.blank?
    "#{user.region.name}, #{user.region.country.name}"
  end

  def user_categories(user)
    return content_tag(:em, t('.unknown')) if user.work_types.empty?
    user.work_types.map { |wt| t("work_types.#{wt.name}") }.join(', ')
  end

  def user_languages(user)
    return content_tag(:em, t('.unknown')) if user.language_skills.empty?
    user.language_skills.map do |ls|
      "#{t(ls.language.name.underscore)} (#{ls.level.text})"
    end.join(', ')
  end

  def i18n_timeago(timestamp)
    t 'datetime.timestamp_ago', time: time_ago_in_words(timestamp)
  end
end
