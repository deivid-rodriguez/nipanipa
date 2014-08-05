module ApplicationHelper

  # Returns the full title on a per-page basis
  def full_title(page_title)
    base_title = "NiPaNiPa"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def signup_page?(path)
    request.path =~ /sign_up/ || current_page?(root_path) || current_page?('/')
  end

  def tab_builder(user, page_id)
    general_tabs = {
      general:  { name: t('.general'), path: user_path(user) },
      feedback: { name: t('.feedback'), path: user_feedbacks_path(user) },
      pictures: { name: t('.pictures'), path: user_pictures_path(user) } }
    content = ""

    if user_signed_in? and current_user == user
      user_tabs = {
        conversations: { name: t('.conversations'), path: conversations_path },
        edit: { name: t('.edit'), path: edit_user_registration_path } }
      tabs = general_tabs.merge(user_tabs)
    else
      tabs = general_tabs
    end

    tabs.each do |tab, options|
      content << if page_id == tab
        content_tag('li',
          content_tag('a', options[:name], href: nil), class: 'active')
      else
        content_tag('li',
           content_tag('a', options[:name], href: options[:path]))
      end
      content += "\n        "
    end
    content.html_safe
  end
end
