module UsersHelper

   # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=wavatar"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
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

end
