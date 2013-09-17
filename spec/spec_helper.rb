ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

# Start code coverage
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/vendor/ruby/'
end

require 'rspec/rails'
require 'rspec/autorun'
require 'cancan/matchers'

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

  config.treat_symbols_as_metadata_keys_with_true_values = true

  # ## Mock Framework (uncomment the appropriate line)
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # Use the core set of syntax methods (build, build_stubbed, create,
  # attributes_for, and their *_list counterparts) without having to call them
  # on FactoryGirl directly
  require 'factory_girl'
  config.include FactoryGirl::Syntax::Methods
end

require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara/mechanize'

Capybara.javascript_driver = :poltergeist
Capybara.asset_host = 'http://nipanipa.local.com'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Forces all threads to share the same connection. capybara drivers start the
# web server in another thread and transactions are not shared between threads
# by default.
ActiveRecord::ConnectionAdapters::ConnectionPool.class_eval do
  def current_connection_id
    Thread.main.object_id
  end
end
