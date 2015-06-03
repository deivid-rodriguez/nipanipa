require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

# Load per environment configuration
def load_configuration
  conf = YAML.load(File.read(File.expand_path('../application.yml', __FILE__)))
  conf.merge! conf.fetch(Rails.env, {})
  conf.each do |key, value|
    ENV[key] = value.to_s unless value.is_a? Hash
  end
end
load_configuration unless ENV['CI'] # We separately set ENV for travis

module Nipanipa
  #
  # Our Rails App
  #
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified
    # here. Application configuration should go into files in
    # config/initializers -- all .rb files in that directory are automatically
    # loaded.

    # Set Time.zone default to the specified zone and make Active Record
    # auto-convert to this zone. Run "rake -D time" for a list of tasks for
    # finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    #
    # Custom libraries autoloaded
    #
    config.autoload_paths += %W(#{config.root}/lib)

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
    config.i18n.load_path += Dir["#{Rails.root}/config/locales/**/*.yml"]
    config.i18n.locale = config.i18n.default_locale = :en
    config.i18n.available_locales = %i(en es fr it de)
    config.i18n.enforce_available_locales = true

    #
    # Mailing
    #
    config.action_mailer.asset_host = "http://#{ENV['MAIL_HOST']}"
    config.action_mailer.default_url_options = { host: ENV['MAIL_HOST'],
                                                 locale: :en }

    #
    # ActiveRecord
    #
    config.active_record.raise_in_transactional_callbacks = true
  end
end
