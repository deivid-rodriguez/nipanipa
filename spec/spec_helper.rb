# --- Instructions ---
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||= 'test'
  unless ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end

  require File.expand_path("../../config/environment", __FILE__)

  require 'rspec/rails'
  require 'rspec/autorun'
  require 'factory_girl'
  require 'cancan/matchers'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  require 'capybara/rails'
  require 'capybara/rspec'

  Capybara.register_driver :webkit_ignore_ssl do |app|
    browser = Capybara::Webkit::Browser.new(Capybara::Webkit::Connection.new
              ).tap do |browser|
      browser.ignore_ssl_errors
    end
    Capybara::Webkit::Driver.new(app, :browser => browser)
  end
  Capybara.javascript_driver = :webkit_ignore_ssl

  RSpec.configure do |config|
    config.include Devise::TestHelpers, :type => :controller

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
    config.include FactoryGirl::Syntax::Methods
  end
end

Spork.each_run do
  if ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end
  FactoryGirl.reload

  ## Forces all threads to share the same connection. capybara-webkit starts the
  ## web server in another thread and transactions are not shared between threads
  ## by default.
  ActiveRecord::ConnectionAdapters::ConnectionPool.class_eval do
    def current_connection_id
      Thread.main.object_id
    end
  end

end
