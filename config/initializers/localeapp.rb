# frozen_string_literal: true

if Rails.env.development?
  require "localeapp/rails"

  Localeapp.configure do |config|
    #
    # Set up API keys
    #
    config.api_key = "JTt7kLxvGkfMcE88EL9QkdN2iVxFq4neTOhJLQejJ75VWPcuIb"

    #
    # Ignore simple_form & activerecord keys
    #
    config.blacklisted_keys_pattern = /simple_form|activerecord/

    #
    # Don't autohandle anything
    #
    config.sending_environments = []
    config.polling_environments = []
  end
end
