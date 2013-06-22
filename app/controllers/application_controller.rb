class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale
  before_filter :update_last_sign_in_at

  protected

    def update_last_sign_in_at
      if user_signed_in? && !session[:logged_signin]
        sign_in(current_user, :force => true)
        session[:logged_signin] = true
      end
    end

  private

    def set_locale
      if params[:locale].present?
        I18n.locale = params[:locale]
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

    def after_sign_in_path_for(resource)
      stored_location_for(resource) || current_user
    end
end
