# frozen_string_literal: true

require "webmock/rspec"

RSpec.configure do |config|
  config.before(:suite) do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  config.after(:suite) do
    WebMock.allow_net_connect!
  end

  config.before(:each, :with_fake_paypal) do
    stub_request(:any, /#{ENV['PAYPAL_HOST']}:#{ENV['PAYPAL_PORT']}/)
      .to_rack(FakePaypalApp.new)
  end
end
