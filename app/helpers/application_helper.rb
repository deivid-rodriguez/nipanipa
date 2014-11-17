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

  def tab_builder(user, page_id)
    general_tabs = {
      general:  { name: t('.general'), path: user_path(user) },
      feedback: { name: t('.feedback'), path: user_feedbacks_path(user) },
      pictures: { name: t('.pictures'), path: user_pictures_path(user) } }
    content = ''

    if user_signed_in? && current_user == user
      user_tabs = {
        conversations: { name: t('.conversations'), path: conversations_path },
        edit: { name: t('.edit'), path: edit_user_registration_path } }
      tabs = general_tabs.merge(user_tabs)
    else
      tabs = general_tabs
    end

    tabs.each do |tab, options|
      content << if page_id == tab
                   content_tag('li', class: 'active') do
                     content_tag('a', options[:name], href: nil)
                   end
                 else
                   content_tag('li') do
                     content_tag('a', options[:name], href: options[:path])
                   end
                 end
      content += "\n        "
    end
    content.html_safe
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
