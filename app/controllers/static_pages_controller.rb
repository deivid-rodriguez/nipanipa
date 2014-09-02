class StaticPagesController < ApplicationController
  def home
    render layout: 'home'
  end

  def help
  end

  def about
  end

  def contact
  end

  def donate
  end

  def terms
  end

  def robots
    robots = File.read(Rails.root + "config/robots.#{Rails.env}.txt")
    render text: robots, layout: false, content_type: 'text/plain'
  end
end
