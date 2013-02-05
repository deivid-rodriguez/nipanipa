class StaticPagesController < ApplicationController
  def home
    @host = Host.new
    @volunteer = Volunteer.new
  end

  def help
  end

  def about
  end

  def contact
  end

  def donate
  end

end
