# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require "simplecov"
SimpleCov.start "rails"

require "spec_helper"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"

require "support/capybara"
require "support/database_cleaner"
require "support/shoulda"
require "support/utilities"
require "support/webmock"

# Checks for pending migrations before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :feature

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryBot.lint
    ensure
      DatabaseCleaner.clean
    end

    Warden.test_mode!
  end

  config.after(:each) do
    Warden.test_reset!
    ActionMailer::Base.deliveries = []
  end

  config.before(:each, type: :feature) do
    default_url_options[:locale] = I18n.default_locale
  end

  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Use the core set of syntax methods (build, build_stubbed, create,
  # attributes_for, and their *_list counterparts) without having to call them
  # on FactoryBot directly
  require "factory_bot_rails"
  config.include FactoryBot::Syntax::Methods
end
