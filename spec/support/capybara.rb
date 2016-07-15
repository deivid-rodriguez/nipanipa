# frozen_string_literal: true

require "capybara/rspec"
require "capybara/rails"
require "capybara/poltergeist"
require "support/port_mapper"
require "support/fake_paypal_app"
require "support/phantomjs"

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, phantomjs: Phantomjs.path)
end

Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  config.before(:suite) { Phantomjs.check }
end

Capybara.asset_host = "http://localhost:3000"

Capybara.app = PortMapper.new(Capybara.app,
                              ENV["PAYPAL_PORT"].to_i => FakePaypalApp)
