require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'support/port_mapper'
require 'support/fake_paypal_app'

Capybara.javascript_driver = :poltergeist

Capybara.asset_host = 'http://localhost:3000'

Capybara.app = PortMapper.new(Capybara.app,
                              ENV['PAYPAL_PORT'].to_i => FakePaypalApp)
