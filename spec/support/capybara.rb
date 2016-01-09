require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist

Capybara.asset_host = 'http://localhost:3000'
