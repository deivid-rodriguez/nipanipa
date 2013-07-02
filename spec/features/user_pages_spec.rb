#
# Integration tests for User pages
#

describe 'Host profile creation' do
  let!(:host) do
    wts = create_list(:work_type, 5)
    build(:host, work_types: wts.sample(3))
  end
  let(:create_user_btn) { t('helpers.submit.user.create') }

  subject { page }

  before { visit new_user_registration_path(type: 'host') }

  it { should have_selector 'h1', text: t('users.new.header',
                                  type: t('activerecord.models.Host')) }
  it { should have_title full_title(t 'users.new.title') }
  it { should have_link 'NiPaNiPa' }

  context 'when submitting invalid information' do
    before do
      expect { click_button create_user_btn }.not_to change(Host, :count)
    end

    it { should have_title t('users.new.title') }
    it { should have_selector '.error' }
  end

  context 'when submitting valid information' do
    before do
      within '.signup-form' do
        fill_in 'user[name]'                 , with: host.name
        fill_in 'user[email]'                , with: host.email
        fill_in 'user[password]'             , with: host.password
        fill_in 'user[password_confirmation]', with: host.password
        fill_in 'user[description]'          , with: host.description
        host.work_type_ids.each { |id| check "user_work_type_ids_#{id}" }
      end
      expect { click_button create_user_btn }.to change(Host, :count).by(1)
    end

    it { should have_title host.name }
    it { should have_flash_message t('devise.users.signed_up'), 'success' }
    it { should have_link t('sessions.signout') }
  end
end

describe 'Volunteer profile creation' do
  let(:volunteer)       { build(:volunteer) }
  let(:create_user_btn) { t('helpers.submit.user.create') }

  subject { page }

  before { visit new_user_registration_path(type: 'volunteer') }

  it { should have_selector 'h1', text: t('users.new.header',
                                  type: t('activerecord.models.Volunteer')) }
  it { should have_title full_title(t 'users.new.title') }
  it { should have_link 'NiPaNiPa' }

  context 'when submitting invalid information' do
    before do
      expect { click_button create_user_btn }.not_to change(Volunteer, :count)
    end

    it { should have_title t('users.new.title') }
    it { should have_selector '.error' }
  end

  context 'when submitting valid information' do
    before do
      within '.signup-form' do
        fill_in 'user[name]'                 , with: volunteer.name
        fill_in 'user[email]'                , with: volunteer.email
        fill_in 'user[password]'             , with: volunteer.password
        fill_in 'user[password_confirmation]', with: volunteer.password
        fill_in 'user[description]'          , with: volunteer.description
      end
      expect { click_button create_user_btn }.to change(Volunteer, :count).by(1)
    end

    it { should have_title volunteer.name }
    it { should have_flash_message t('devise.users.signed_up'), 'success' }
    it { should have_link t('sessions.signout') }
  end
end

describe 'User profile display' do
  let(:new_feedback)  { t('shared.profile_header.new_feedback')  }
  let(:edit_feedback) { t('shared.profile_header.edit_feedback') }
  let(:feedback)  { create(:feedback)  }
  let(:sender)    { feedback.sender    }
  let(:recipient) { feedback.recipient }

  subject { page }

  # Force trackable hook ups and ip geolocation to happen
  # This should be forced in creation...
  before do
    visit root_path
    sign_in sender
    sign_out
    sign_in recipient
    sign_out
  end

  shared_examples_for 'user profile' do
    it { should have_selector('h3', text: user.name) }
    it { should have_title user.name }
    it { should have_content(user.description) }
    it { should have_content(feedback.content) }
    it { should have_content(user.received_feedbacks.count) }
  end

  context 'when visitor is the profile owner' do
    before { sign_in recipient }

    it_behaves_like 'user profile' do
      let(:user) { recipient }
    end
    it { should_not have_link new_feedback  }
    it { should_not have_link edit_feedback }
  end

  context 'when visitor is not signed in' do
    before { visit user_path sender }

    it_behaves_like 'user profile' do
      let(:user) { sender }
    end
    it { should_not have_link new_feedback  }
    it { should_not have_link edit_feedback }
  end

  context 'when visitor already left feedback' do
    before do
      sign_in sender
      visit user_path recipient
    end

    it_behaves_like 'user profile' do
      let(:user) { recipient }
    end
    it { should_not have_link new_feedback  }
    it { should have_link edit_feedback }
  end

  context 'when visitor did not leave feedback yet' do
    before do
      sign_in recipient
      visit user_path sender
    end

    it_behaves_like 'user profile' do
      let(:user) { sender }
    end
    it { should have_link new_feedback  }
    it { should_not have_link edit_feedback }
  end
end

describe 'User profile removing' do

end

describe 'User profile index' do
  before do
    2.times { create(:host) }
    2.times { create(:volunteer) }
    visit users_path
  end

  it 'lists all profiles' do
    User.paginate(page: 1).each do |user|
      page.should have_selector('li', text: user.name)
    end
  end
end

describe 'User profile editing' do
  let(:host)        { create(:host, email: 'old_email@example.com') }
  let(:update_user) { t('helpers.submit.user.update', model: User)  }

  subject { page }

  before do
    visit root_path
    sign_in host
    visit edit_user_registration_path
  end

  it { should have_title t('users.edit.title') }

  context 'with invalid information' do
    before do
      fill_in 'user[email]', with: 'invalid@example'
      click_button update_user
    end

    it { should have_selector '.error' }
  end

  context 'with nothing introduced' do
    before { click_button update_user }

    it { should have_flash_message t('devise.users.updated'), 'success' }
  end

  context 'with valid information' do
    before do
      fill_in 'user[email]', with: 'new_email@example.com'
      click_button update_user
    end

    it { should have_flash_message t('devise.users.updated'), 'success' }
    it { should have_link t('sessions.signout'), href: destroy_user_session_path }
    it 'updates host correctly' do
      host.reload.email.should == 'new_email@example.com'
    end
  end
end
