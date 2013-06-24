module UsersHelper

  def avatar_for user, options = { style: :small }
    main_pict = user.main_picture
    style = options[:style]
    default_avatar = "default_avatar_#{style.to_s}.png"
    url = main_pict.nil? ? default_avatar : main_pict.image.url(style)
    image_tag url, alt: 'Profile Picture'
  end

  def index_title(type)
    if type == 'host'
      t 'users.index.all_hosts'
    elsif type == 'volunteer'
      t 'users.index.all_volunteers'
    else
      t 'users.index.all_users'
    end
  end

  def feedback_count(feedbacks)
    "#{t 'feedbacks.feedbacks.title'} " \
    "( #{t 'feedbacks.received', count: @feedback_pairs.count{ |f| !f[0].nil? }}" \
    ", #{t 'feedbacks.sent', count: @feedback_pairs.count{ |f| !f[1].nil? }} )"
  end

end
