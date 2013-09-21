#
# Integration tests for Authentication pages
#

describe 'Signin' do
  let(:signin)  { t 'sessions.signin'    }
  let(:signout) { t 'sessions.signout'   }
  let(:profile) { t 'users.show.profile' }
  let(:user)    { create(:host)          }

  subject { page }

  before { visit root_path }

  describe 'page has correct content' do
    before { visit new_user_session_path }

    it { should have_title signin }
  end

  describe 'dropdown menu has correct content' do
    before { click_link signin }

    it { should have_selector 'input#user_email' }
    it { should have_selector 'input#user_password' }
  end


  # XXX: Review.. this fields are currently set in the factory
  describe 'geolocation' do
    before { sign_in user }

    it 'correctly sets user location by geolocating the ip' do
      user.reload.longitude.should_not be_nil
      user.reload.latitude.should_not be_nil
      user.reload.state.should_not be_nil
      user.reload.country.should_not be_nil
    end
  end

  context 'with invalid information' do
    before do
      click_link signin
      click_button signin
    end

    it { should have_title signin }
    it { should have_flash_message t('devise.failure.invalid'), 'error' }
  end

  context 'with valid information' do
    before { sign_in user }

    it { should have_title user.name }
    it { should have_link profile, href: user_path(user) }
    it { should_not have_link signin, href: new_user_session_path }

    context 'and then signout' do
      before { click_link signout }

      it { should have_link signin }
      it { should_not have_link profile, href: user_path(user) }
      it { should_not have_link signout }
    end
  end
end # signin

describe 'Password recovery' do
  let!(:user) { create(:volunteer) }

  subject { page }

  before do
    visit root_path
    click_link t('sessions.signin')
    click_link t('sessions.forgot_your_pwd?')
  end

  shared_examples 'paranoid' do
    it { should have_flash_message \
                t('devise.passwords.send_paranoid_instructions'), 'success' }
  end

  context 'with correct email' do
    before do
      within 'div.signin-thumbnail' do
        fill_in 'user[email]', with: user.email
        click_button t('devise.passwords.new.send_instructions')
      end
    end

    it_behaves_like 'paranoid'
    it { sends_notification_email(user) }
  end

  context 'with wrong email' do
    before do
      within 'div.signin-thumbnail' do
        fill_in 'user[email]', with: "mywrongemail@example.com"
        click_button t('devise.passwords.new.send_instructions')
      end
    end

    it_behaves_like 'paranoid'
    it { doesnt_send_notification_email(user) }
  end
end
