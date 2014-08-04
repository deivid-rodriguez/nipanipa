ENV["RAILS_ENV"] ||= 'test'
# Start code coverage
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/vendor/ruby/'
end

require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :feature

  config.before(:suite) { Warden.test_mode! }

  config.after(:each) do
    Warden.test_reset!
    ActionMailer::Base.deliveries = []
  end

  config.before(:each, type: :feature) do
    default_url_options[:locale] = I18n.default_locale
  end

  # Run each example within a transaction
  config.use_transactional_fixtures = true

  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Use the core set of syntax methods (build, build_stubbed, create,
  # attributes_for, and their *_list counterparts) without having to call them
  # on FactoryGirl directly
  require 'factory_girl'
  config.include FactoryGirl::Syntax::Methods
end

require 'cancan/matchers'

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.asset_host = 'http://nipanipa.local.com'

# Forces all threads to share the same connection. capybara drivers start the
# web server in another thread and transactions are not shared between threads
# by default.
ActiveRecord::ConnectionAdapters::ConnectionPool.class_eval do
  def current_connection_id
    Thread.main.object_id
  end
end
