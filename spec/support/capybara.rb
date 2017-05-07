# frozen_string_literal: true

require "capybara/rspec"
require "capybara/rails"
require "capybara/poltergeist"
require "support/port_mapper"
require "support/fake_paypal_app"

Capybara.javascript_driver = :poltergeist

# _NOTE_: `save_and_open_page` with propes styles requires a running development
# server on this host _and_ `config.assets.debug = true` in
# `config/environments/test.rb`.
Capybara.asset_host = "http://localhost:3000"

Capybara.app = PortMapper.new(Capybara.app,
                              ENV["PAYPAL_PORT"].to_i => FakePaypalApp.new)
