include ApplicationHelper

def sign_in(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # sign in when no using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

def fill_profile(name, email, password)
  fill_in "Name",             with: name
  fill_in "Email",            with: email
  fill_in "Password",         with: password
  fill_in "Confirm Password", with: password
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

#RSpec::Matchers.define :have_signin_title do
#  match do |page|
#    page.should have_selector('title', text: 'Sign in')
#  end
#end
