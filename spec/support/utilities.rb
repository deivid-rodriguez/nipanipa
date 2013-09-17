include ApplicationHelper

def t(string, options = {})
  I18n.t(string, options)
end

def sign_in(user)
  click_link t('sessions.signin')
  fill_in 'user[email]',    with: user.email
  fill_in 'user[password]', with: user.password
  click_button t('sessions.signin')
end

def mock_sign_in(user)
  login_as user
  visit user_path(user)
end

def sends_notification_email(recipient)
  expect(ActionMailer::Base.deliveries.last.to).to include(recipient.email)
end

def sign_out
  click_link t('sessions.signout')
end

def reply(text)
  fill_in 'body', with: "#{text}"
  click_button t('conversations.show.reply')
  page.should have_content "#{text}" # assert text appears before going on
end

RSpec::Matchers.define :become do |count|
  match do |block|
    begin
      value = block.call
      if value != count
        Timeout.timeout(Capybara.default_wait_time) do
          begin
            sleep(0.1)
            value = block.call
          end until value == count
          true
        end
      else
        true
      end
    rescue TimeoutError
      false
    end
  end
end

RSpec::Matchers.define :have_flash_message do |message, type|
  match do |page|
    page.should have_selector("div.alert.alert-#{type}", text: message)
  end
end

##
# Examples
# @user.should have_ability(:create, for: Post.new)
# @user.should have_ability([:create, :read], for: Post.new)
# @user.should have_ability(
#   {create: true, read: false, update: false, destroy: true}, for: Post.new)
RSpec::Matchers.define :have_ability do |ability_hash, options = {}|
  match do |user|
    ability         = Ability.new(user)
    target          = options[:for]
    @ability_result = {}
    ability_hash    = {ability_hash => true} if ability_hash.is_a? Symbol
    ability_hash    = ability_hash.inject({}){|_, i| _.merge({i=>true}) } if
      ability_hash.is_a? Array
    ability_hash.each do |action, true_or_false|
      @ability_result[action] = ability.can?(action, target)
    end
    ability_hash == @ability_result
  end

  failure_message_for_should do |user|
    ability_hash,options = expected
    ability_hash         = {ability_hash => true} if ability_hash.is_a? Symbol
    ability_hash         = ability_hash.inject({}){|_, i| _.merge({i=>true}) } if
      ability_hash.is_a? Array
    target               = options[:for]
    message = "expected User:#{user} to have ability:#{ability_hash} for " \
              "#{target}, but actual result is #{@ability_result}"
  end

  # clean up output of RSpec Documentation format
  description do
    if ability_hash.length == 1
      "have ability #{expected.to_s.match(/(:[^ ]*)/)[1]} " \
      "for #{expected.to_s.match(/<([^ ]*)/)[1]}"
    else
      "have abilities #{expected.to_s.match(/\[(\[[^\]]*\]),/)[1]} " \
      "for #{expected.to_s.match(/<([^ ]*)/)[1]}"
    end
  end
end
