module UsersHelper

  def avatar_for user, options = { style: :small_cropped }
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
    ret = "#{t 'feedbacks.feedbacks.title'}"
    if received_count != 0 || sent_count != 0
      ret += " (%s, %s)" % [
        t('feedbacks.received', count: received_count),
        t('feedbacks.sent', count: sent_count)
      ]
    end
  end

end
