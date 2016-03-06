# frozen_string_literal: true

#
# Miscelaneous helpers for rendering views
#
module ApplicationHelper
  #
  # Instantiates a proper presenter for a user
  #
  def present(user)
    return OwnedProfilePresenter.new(user, self) if user == current_user

    ExternalProfilePresenter.new(user, current_user, self)
  end

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

  def active_if_same_canonical(path)
    return "" unless path == url_for(locale: I18n.locale)

    "active"
  end

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
