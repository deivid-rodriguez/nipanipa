# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Nipanipa
  #
  # Our Rails App
  #
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified
    # here. Application configuration should go into files in
    # config/initializers -- all .rb files in that directory are automatically
    # loaded.

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Set Time.zone default to the specified zone and make Active Record
    # auto-convert to this zone. Run "rake -D time" for a list of tasks for
    # finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    #
    # Silence assets log
    #
    config.assets.logger = false

    #
    # Generators automatically generate factories instead of fixtures
    #
    config.generators do |g|
      g.test_framework :rspec, fixture: false,
                               view_specs: false,
                               helper_specs: false
      g.javascripts false
      g.helper false
    end

    #
    # I18n configuration
    #
    config.i18n.load_path +=
      Dir[Rails.root.join("config", "locales", "**", "*.yml")]
    config.i18n.locale = config.i18n.default_locale = :en
    config.i18n.available_locales = %i[en es fr it de]
    config.i18n.enforce_available_locales = true

    #
    # Mailing
    #
    config.action_mailer.asset_host = "http://#{ENV['MAIL_HOST']}"
    config.action_mailer.default_url_options = { host: ENV["MAIL_HOST"],
                                                 locale: :en }
  end
end
