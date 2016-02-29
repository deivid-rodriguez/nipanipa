# frozen_string_literal: true

#
# Miscelaneous helpers for rendering views
#
module ApplicationHelper
  #
  # Returns brand logo image to be used
  #
  def logo_pic
    params[:action] == "home" ? "logo_home.png" : "logo.png"
  end

  #
  # Returns the full title on a per-page basis
  #
  def full_title(page_title)
    base_title = "NiPaNiPa"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def signup_page?(_path)
    request.path =~ /sign_up/ || current_page?(root_path) || current_page?("/")
  end

  def sym_params
    params.symbolize_keys
  end

  def i18n_timeago(timestamp)
    return t("shared.never") unless timestamp

    t("shared.timestamp_ago", time: time_ago_in_words(timestamp))
  end

  def active_if_same_canonical(path)
    return "" unless path == url_for(locale: I18n.locale)

    "active"
  end

  def owner_tabs(user)
    [
      { name: tab_name("general"), path: user_path(user) },
      { name: tab_name("feedback"), path: user_feedbacks_path(user) },
      { name: tab_name("pictures"), path: user_pictures_path(user) }
    ]
  end

  def tabs_for(user)
    tabs = owner_tabs(user)
    return tabs unless user_signed_in? && current_user == user

    tabs + [{ name: tab_name("messages"), path: conversations_path }]
  end

  def actions_for(user)
    return owner_links if current_user && user == current_user

    [{ name: tab_name("new_message"),
       dest: conversation_path(user),
       class: "envelope" },
     { name: tab_name("new_feedback"),
       dest: feedback_destination(current_user, user),
       class: "ok" }]
  end

  def owner_links
    [{ name: link_name("edit"),
       dest: edit_user_registration_path,
       class: "pencil" },
     { name: link_name("delete"),
       dest: confirm_delete_account_path,
       class: "trash" }]
  end

  def tab_name(key)
    t("shared.profile_header.#{key}")
  end

  alias link_name tab_name

  #
  # Bootstrap 3 <-> Rails 4 flash messages compatibility
  #
  BOOTSTRAP_FLASH_MSG = {
    success: "alert-success",
    error: "alert-danger",
    alert: "alert-danger",
    notice: "alert-success",
    info: "alert-info"
  }.freeze

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSG.fetch(flash_type.to_sym, flash_type.to_s)
  end
end
