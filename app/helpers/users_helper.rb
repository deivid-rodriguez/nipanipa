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

    content_tag(:span, "#{key} #{value || unknown}".html_safe)
  end

  def karma_to_type(karma)
    return 1 if karma < 0
    return 2 if karma == 0
    return 3 if karma == 1
    return 4 if karma >= 2 && karma < 10
    5
  end

  def user_location(user)
    return if user.region.blank?
    "#{user.region.name}, #{user.region.country.name}"
  end

  def user_categories(user)
    return if user.work_types.empty?
    user.work_types.map { |wt| t("work_types.#{wt.name}") }.join(", ")
  end

  def user_languages(user)
    return if user.language_skills.empty?
    user.language_skills.map do |ls|
      "#{t(ls.language.code)} (#{ls.level.text})"
    end.join(", ")
  end

  def unknown
    content_tag(:em, t("shared.unknown"))
  end
end
