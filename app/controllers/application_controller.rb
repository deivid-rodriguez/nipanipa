class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  include SessionsHelper

private

  def set_locale
    if params[:locale].present?
      I18n.locale = params[:locale] if params[:locale].present?
    else
      I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'][/^[a-z]{2}/]
    end
    # current_user.locale
    # request.subdomain
    # request.remote_ip
  end

  def default_url_options(options = {})
    {locale: I18n.locale}
  end
end
