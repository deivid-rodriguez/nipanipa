include ApplicationHelper

def sign_in(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

# Access fiels by "name" because content is ambiguous
def fill_signin_info(name, email, password)
  fill_in 'user[name]'                 , with: name
  fill_in 'user[email]'                , with: email
  fill_in 'user[password]'             , with: password
  fill_in 'user[password_confirmation]', with: password
end


RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message)
  end
end

RSpec::Matchers.define :have_title do |text|
  match do |page|
    Capybara.string(page.body).has_selector?('title', text: text)
  end
end
