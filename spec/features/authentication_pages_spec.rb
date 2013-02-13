require 'spec_helper'

feature "Signin" do

  let(:signin)  { t 'sessions.signin'    }
  let(:signout) { t 'sessions.signout'   }
  let(:profile) { t 'users.show.profile' }
  let(:user)    { create(:user)          }

  background { visit new_user_session_path }

  scenario "Signin page has correct content" do
    page.should have_selector 'h1', text: signin
    page.should have_title signin
  end

  scenario "with invalid information should take you back to signin page and
            show error message" do
    click_button signin

    page.should have_title signin
    page.should have_error_message t('devise.failure.invalid')
  end

  scenario "valid information followed by signout" do
    sign_in user

    page.should have_title user.name
    page.should have_link profile, href: user_path(user)
    page.should_not have_link signin, href: new_user_session_path

    click_link signout

    page.should have_link signin, href: new_user_session_path
    page.should_not have_link profile, href: user_path(user)
    page.should_not have_link signout
  end

end # signin
