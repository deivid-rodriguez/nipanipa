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

  def feedback_count feedbacks
    received_count = feedbacks.count { |f| !!f[0] }
    sent_count     = feedbacks.count { |f| !!f[1] }
    if received_count == 0 and sent_count == 0
      "#{t 'feedbacks.feedbacks.title'}"
    else
      "#{t 'feedbacks.feedbacks.title'}("                  \
      "#{t 'feedbacks.received', count: received_count}, " \
      "#{t 'feedbacks.sent', count: sent_count})"
    end
  end

end
