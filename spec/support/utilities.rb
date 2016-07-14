# frozen_string_literal: true

include ApplicationHelper

def t(string, options = {})
  I18n.t(string, options)
end

def sign_in(user)
  click_link t("sessions.signin")
  fill_in "user[email]", with: user.email
  fill_in "user[password]", with: user.password
  click_button t("sessions.signin")
end

def mock_sign_in(user)
  login_as(user, scope: :user, run_callbacks: false)
end

def sent_emails
  ActionMailer::Base.deliveries
end

def last_email
  sent_emails.last
end

# TODO: convert to a matcher
def sign_out
  click_link t("sessions.signout")
end

def reply(text)
  fill_in "message_body", with: text.to_s
  click_button t("helpers.submit.message.create")
  expect(page).to have_content text.to_s # assert text appears before going on
end

RSpec::Matchers.define :become do |count|
  match do |block|
    begin
      value = block.call
      if value != count
        Timeout.timeout(Capybara.default_max_wait_time) do
          loop do
            sleep(0.1)
            value = block.call
            break if value == count
          end
          true
        end
      else
        true
      end
    rescue TimeoutError
      false
    end
  end

  def supports_block_expectations?
    true
  end
end

RSpec::Matchers.define :have_flash_message do |message, type|
  match do |page|
    expect(page).to have_selector("div.alert.alert-#{type}", text: message)
  end
end
