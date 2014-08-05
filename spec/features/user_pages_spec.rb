#
# Integration tests for User pages
#

RSpec.shared_examples_for 'user profile' do
  it 'has the user name in the title' do
    expect(page).to have_title user.name
  end
  it 'has the user description' do
    expect(page).to have_content(user.description)
  end
  it 'has all received feedback' do
    user.received_feedbacks.each { |f| expect(page).to have_content(f.content) }
  end
  it 'has the count of received feedback' do
    expect(page).to have_content(user.received_feedbacks.count)
  end
  it 'has all sent feedback' do
    user.sent_feedbacks.each { |f| expect(page).to have_content(f.content) }
  end
  it 'has the count of sent feedback' do
    expect(page).to have_content(user.sent_feedbacks.count)
  end
  it 'has all of user worktypes' do
    user.work_types.each { |wt| expect(page).to have_content(wt.name) }
  end
  it 'has correct user availability' do
    expect(page).to have_content("✘ ✔ ✘ ✘ ✘ ✘ ✘ ✘ ✘ ✘ ✘")
  end
end

RSpec.describe 'Profile creation' do
  let(:work_types) { create_list(:work_type, 5) }

  describe 'Host' do
    let!(:host) { build(:host, work_types: work_types.sample(3)) }
    let(:create_user_btn) { t('helpers.submit.user.create') }

    subject { page }

    before do
      create(:language, code: I18n.locale)
      visit new_user_registration_path(type: 'host')
    end

    it { is_expected.to have_selector 'h1', text: t('users.new.header', type: t('activerecord.models.host')).titleize }
    it { is_expected.to have_title full_title(t 'users.new.title') }
    it { is_expected.to have_link 'NiPaNiPa' }

    context 'when submitting invalid information' do
      before do
        expect { click_button create_user_btn }.not_to change(Host, :count)
      end

      it { is_expected.to have_title t('users.new.title') }
      it { is_expected.to have_selector '.has-error' }
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
          check "user_availability_feb"
        end
        expect { click_button create_user_btn }.to change(Host, :count).by(1)
      end

      it { is_expected.to have_title host.name }
      it { is_expected.to have_flash_message t('devise.users.signed_up'), 'success' }
      it { is_expected.to have_link t('sessions.signout') }
    end
  end

  describe 'Volunteer' do
    let(:volunteer)       { build(:volunteer) }
    let(:create_user_btn) { t('helpers.submit.user.create') }

    subject { page }

    before do
      create(:language, code: I18n.locale)
      visit new_user_registration_path(type: 'volunteer')
    end

    it { is_expected.to have_selector 'h1', text: t('users.new.header', type: t('activerecord.models.volunteer')).titleize }
    it { is_expected.to have_title full_title(t 'users.new.title') }
    it { is_expected.to have_link 'NiPaNiPa' }

    context 'when submitting invalid information' do
      before do
        expect { click_button create_user_btn }.not_to change(Volunteer, :count)
      end

      it { is_expected.to have_title t('users.new.title') }
      it { is_expected.to have_selector '.has-error' }
    end

    context 'when submitting valid information' do
      before do
        within '.signup-form' do
          fill_in 'user[name]'                 , with: volunteer.name
          fill_in 'user[email]'                , with: volunteer.email
          fill_in 'user[password]'             , with: volunteer.password
          fill_in 'user[password_confirmation]', with: volunteer.password
          fill_in 'user[description]'          , with: volunteer.description
          volunteer.work_type_ids.each { |id| check "user_work_type_ids_#{id}" }
          check "user_availability_feb"
        end
        expect { click_button create_user_btn }.to change(Volunteer, :count).by(1)
      end

      it_behaves_like('user profile') { let(:user) { volunteer } }
      it { is_expected.to have_title volunteer.name }
      it { is_expected.to have_flash_message t('devise.users.signed_up'), 'success' }
      it { is_expected.to have_link t('sessions.signout') }
    end
  end
end

RSpec.describe 'User profile index' do
  let!(:host_available)          { create(:host, :available_just_now)      }
  let!(:host_not_available)      { create(:host, :not_available)           }
  let!(:volunteer_available)     { create(:volunteer, :available_just_now) }
  let!(:volunteer_not_available) { create(:volunteer, :not_available)      }

  before { visit users_path }

  it 'lists all profiles' do
    User.all.each do |user|
      expect(page).to have_selector('li', text: user.name)
    end
  end

  describe 'available profiles' do
    before { click_link t('users.index.now') }

    describe 'filtering' do
      it 'shows correct list' do
        expect(page).to have_selector('li', text: host_available.name)
        expect(page).to have_selector('li', text: volunteer_available.name)
        expect(page).not_to have_selector('li', text: host_not_available.name)
        expect(page).not_to have_selector('li', text: volunteer_not_available.name)
      end
    end

    describe 'unfiltering' do
      before { click_link t('users.index.whenever') }

      it 'shows correct list' do
        expect(page).to have_selector('li', text: host_available.name)
        expect(page).to have_selector('li', text: volunteer_available.name)
        expect(page).to have_selector('li', text: host_not_available.name)
        expect(page).to have_selector('li', text: volunteer_not_available.name)
      end
    end
  end

  describe 'host profiles' do
    before { click_link t('users.index.hosts') }

    describe 'filtering' do
      it 'shows correct list' do
        expect(page).to have_selector('li', text: host_available.name)
        expect(page).not_to have_selector('li', text: volunteer_available.name)
        expect(page).to have_selector('li', text: host_not_available.name)
        expect(page).not_to have_selector('li', text: volunteer_not_available.name)
      end
    end

    describe 'unfiltering' do
      before { click_link t('users.index.all') }

      it 'shows correct list' do
        expect(page).to have_selector('li', text: host_available.name)
        expect(page).to have_selector('li', text: volunteer_available.name)
        expect(page).to have_selector('li', text: host_not_available.name)
        expect(page).to have_selector('li', text: volunteer_not_available.name)
      end
    end
  end

  describe 'volunteer profiles' do
    before { click_link t('users.index.volunteers') }

    describe 'filtering' do
      it 'shows correct list' do
        expect(page).not_to have_selector('li', text: host_available.name)
        expect(page).to have_selector('li', text: volunteer_available.name)
        expect(page).not_to have_selector('li', text: host_not_available.name)
        expect(page).to have_selector('li', text: volunteer_not_available.name)
      end
    end

    describe 'unfiltering' do
      before { click_link t('users.index.all') }

      it 'shows correct list' do
        expect(page).to have_selector('li', text: host_available.name)
        expect(page).to have_selector('li', text: volunteer_available.name)
        expect(page).to have_selector('li', text: host_not_available.name)
        expect(page).to have_selector('li', text: volunteer_not_available.name)
      end
    end
  end

  describe 'mixed filters' do
    before do
      click_link t('users.index.hosts')
      click_link t('users.index.now')
    end

    it 'shows correct list' do
      expect(page).to have_selector('li', text: host_available.name)
      expect(page).not_to have_selector('li', text: volunteer_available.name)
      expect(page).not_to have_selector('li', text: host_not_available.name)
      expect(page).not_to have_selector('li', text: volunteer_not_available.name)
    end
  end
end

RSpec.describe 'User profile editing' do
  let(:host)        { create(:host, email: 'old_email@example.com') }
  let(:update_user) { t('helpers.submit.user.update', model: User)  }

  subject { page }

  before do
    visit root_path
    sign_in host
    visit edit_user_registration_path
  end

  it { is_expected.to have_title t('users.edit.title') }

  context 'with invalid information' do
    before do
      fill_in 'user[email]', with: 'invalid@example'
      click_button update_user
    end

    it { is_expected.to have_selector '.has-error' }
  end

  context 'with nothing introduced' do
    before { click_button update_user }

    it { is_expected.to have_flash_message t('devise.users.updated'), 'success' }
  end

  context 'with valid information' do
    before do
      fill_in 'user[email]', with: 'new_email@example.com'
      click_button update_user
    end

    it { is_expected.to have_flash_message t('devise.users.updated'), 'success' }
    it { is_expected.to have_link t('sessions.signout'), href: destroy_user_session_path }
    it 'updates host correctly' do
      expect(host.reload.email).to eq('new_email@example.com')
    end
    it 'redirects back to user profile' do
      expect(current_path).to eq(user_path(host))
    end
  end
end
