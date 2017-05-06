# frozen_string_literal: true

#
# Main controller, every controller overrides this one
#
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :update_last_sign_in_at
  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action :store_location

  def default_url_options
    { locale: I18n.locale }
  end

  protected

  def authenticate_admin_user!
    authenticate_user! && current_user.admin_at?
  end

  def update_last_sign_in_at
    return unless user_signed_in? && !session[:logged_signin]

    sign_in(current_user, force: true)
    session[:logged_signin] = true
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: permitted_params)
    devise_parameter_sanitizer.permit(:account_update, keys: permitted_params)
  end

  def permitted_params
    return volunteer_params if resource_class == Volunteer
    return host_params if resource_class == Host
  end

  private

  def set_locale
    I18n.locale = params[:locale].presence || browser_lng || I18n.default_locale

    ActionMailer::Base.default_url_options[:locale] = I18n.locale
  end

  def browser_lng
    return if request.env["HTTP_ACCEPT_LANGUAGE"].blank?

    lang = request.env["HTTP_ACCEPT_LANGUAGE"][/^[a-z]{2}/].to_sym
    return unless I18n.available_locales.include?(lang)

    lang
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || current_user
  end

  # store last url for post-login redirect to whatever the user last visited
  def store_location
    return unless store_location?

    session[:user_return_to] = request.fullpath
  end

  def store_location?
    request.fullpath !~ /(confirmation|signin|signout|join|password)/ && \
      request.fullpath != root_path && !request.xhr?
  end
end
