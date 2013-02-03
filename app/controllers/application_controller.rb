class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  include SessionsHelper

private

  def set_locale
    if params[:locale].present?
      I18n.locale = params[:locale] if params[:locale].present?
    elsif request.env['HTTP_ACCEPT_LANGUAGE'].present?
      I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'][/^[a-z]{2}/]
    else
      I18n.locale = I18n.default_locale
    end

    Rails.application.routes.default_url_options[:locale]= I18n.locale
    # current_user.locale
    # request.subdomain
    # request.remote_ip
  end

end
