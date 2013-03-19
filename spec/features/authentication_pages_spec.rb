feature "Signin" do

  let(:signin)  { t 'sessions.signin'    }
  let(:signout) { t 'sessions.signout'   }
  let(:profile) { t 'users.show.profile' }
  let(:user)    { create(:host)          }

  background { visit new_user_session_path }

  scenario "Signin page has correct content" do
    page.should have_title signin
  end

  scenario "Signin correctly sets user location by geolocating the ip" do
    sign_in user

    user.reload.longitude.should_not be_nil
    user.reload.latitude.should_not be_nil
    user.reload.state.should_not be_nil
    user.reload.country.should_not be_nil
  end

  scenario "with invalid information should take you back to signin page and
            show error message" do
    click_button signin

    page.should have_title signin
    page.should have_flash_message t('devise.failure.invalid'), 'error'
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
