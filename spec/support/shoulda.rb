# frozen_string_literal: true

#
# Configure matchers
#
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :active_model
    with.library :active_record
  end
end
