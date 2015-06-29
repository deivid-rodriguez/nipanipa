require 'capybara/rspec'
require 'capybara/rails'

Capybara.javascript_driver = :webkit
Capybara.asset_host = 'http://localhost:3000'
