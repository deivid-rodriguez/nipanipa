# frozen_string_literal: true

require "capybara/rspec"
require "capybara/rails"
require "selenium-webdriver"
require "support/port_mapper"
require "support/fake_paypal_app"

Capybara.register_driver :chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    "chromeOptions" => { "args" => %w[headless] }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: caps
  )
end

Capybara.javascript_driver = :chrome

# _NOTE_: `save_and_open_page` with propes styles requires a running development
# server on this host _and_ `config.assets.debug = true` in
# `config/environments/test.rb`.
Capybara.asset_host = "http://localhost:3000"

Capybara.app = PortMapper.new(Capybara.app,
                              ENV["PAYPAL_PORT"].to_i => FakePaypalApp.new)
