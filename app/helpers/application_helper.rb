#
# Miscelaneous helpers for rendering views
#
module ApplicationHelper
  #
  # Returns the full title on a per-page basis
  #
  def full_title(page_title)
    base_title = 'NiPaNiPa'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def signup_page?(_path)
    request.path =~ /sign_up/ || current_page?(root_path) || current_page?('/')
  end

  def sym_params
    params.symbolize_keys
  end

  def i18n_timeago(timestamp)
    t 'shared.timestamp_ago', time: time_ago_in_words(timestamp)
  end

  def tab_builder(user)
    tabs = {
      general: { name: t('.general'), path: user_path(user) },
      feedback: { name: t('.feedback'), path: user_feedbacks_path(user) },
      pictures: { name: t('.pictures'), path: user_pictures_path(user) }
    }

    if user_signed_in? && current_user == user
      tabs[:messages] = { name: t('.messages'), path: conversations_path }
    end

    tabs
  end

  def link_builder(user)
    return [{ name: t('.edit'),
              dest: edit_user_registration_path,
              class: 'pencil' },
            { name: t('.delete'),
              dest: confirm_delete_account_path,
              class: 'trash' }] if current_user && user == current_user

    [{ name: t('.new_feedback'),
       dest: feedback_destination(current_user, user),
       class: 'envelope' },
     { name: t('.new_message'),
       dest: conversation_path(user),
       class: 'ok' }]
  end

  #
  # Bootstrap 3 <-> Rails 4 flash messages compatibility
  #
  BOOTSTRAP_FLASH_MSG = {
    success: 'alert-success',
    error: 'alert-danger',
    alert: 'alert-danger',
    notice: 'alert-success',
    info: 'alert-info'
  }

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSG.fetch(flash_type.to_sym, flash_type.to_s)
  end
end
