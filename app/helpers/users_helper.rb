module UsersHelper

  def avatar_for user, options = { style: :small }
    style = options[:style]
    main_pict = user.main_picture
    if main_pict
      url = main_pict.image.url(style)
      alt = main_pict.name
    else
      url = "default_avatar_#{style.to_s}.png"
      alt = 'Default avatar'
    end
    image_tag url, alt: alt
  end

  def feedback_count(feedbacks)
    "#{t 'feedbacks.feedbacks.title'} " \
    "( #{t 'feedbacks.received', count: @feedback_pairs.count{ |f| !f[0].nil? }}" \
    ", #{t 'feedbacks.sent', count: @feedback_pairs.count{ |f| !f[1].nil? }} )"
  end

end
