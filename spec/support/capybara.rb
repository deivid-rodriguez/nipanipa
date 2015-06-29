require 'capybara/rspec'
require 'capybara/rails'

Capybara.javascript_driver = :webkit
Capybara.asset_host = 'http://localhost:3000'

Capybara::Webkit.configure do |config|
  config.block_unknown_urls

  config.allow_url('*flattr*')
end
