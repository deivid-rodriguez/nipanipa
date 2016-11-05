# frozen_string_literal: true

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

  def badge_content(name, value)
    badge = t("shared.badge.#{name}")
    key = content_tag(:strong, "#{badge}:")

    content_tag(:span, safe_join([key, value || unknown], " "))
  end

  def karma_to_type(karma)
    return 1 if karma.negative?
    return 2 if karma.zero?
    return 3 if karma == 1
    return 4 if karma >= 2 && karma < 10
    5
  end

  def unknown
    content_tag(:em, t("shared.unknown"))
  end
end
