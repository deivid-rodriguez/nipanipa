#
# Integration tests for User pages
#

RSpec.shared_examples_for 'A user profile creation' do
  let(:create_btn) { t('helpers.submit.user.create') }
  let(:role) { klass.name.underscore }
  let!(:user) { build(role.to_sym) }
  let!(:region) { create(:region) }
  let!(:lang) { create(:language) }
  let!(:work_type) { create(:work_type) }

  before { visit new_user_registration_path(type: role) }

  it 'shows correct header' do
    role_i18n = t("activerecord.models.#{role}")
    header = t('users.new.header', type: role_i18n).titleize

    expect(page).to have_selector 'h1', text: header
  end

  it 'shows correct page title' do
    expect(page).to have_title full_title(t 'users.new.title')
  end

  it 'shows home link' do
    expect(page).to have_link 'NiPaNiPa'
  end

  context 'when submitting invalid information' do
    before do
      expect { click_button create_btn }.not_to change(klass, :count)
    end

    it 'goes back to new user page' do
      expect(page).to have_title t('users.new.title')
    end

    it 'shows a field with an error' do
      expect(page).to have_selector '.has-error'
    end
  end

  context 'when submitting valid information' do
    before do
      within '.signup-form' do
        fill_in 'user[name]', with: user.name
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        fill_in 'user[password_confirmation]', with: user.password
        fill_in 'user[description]', with: user.description
        select lang.name, from: 'user_language_skills_attributes_0_language_id'
        select 'Expert', from: 'user_language_skills_attributes_0_level'
        check "user_work_type_ids_#{work_type.id}"
        check 'user_availability_feb'
      end

      expect { click_button create_btn }.to change(klass, :count).by(1)
    end

    it 'shows a success flash message' do
      expect(page).to have_flash_message \
        t('devise.registrations.signed_up_but_unconfirmed'), 'success'
    end

    it 'does not login the unconfirmed user' do
      expect(page).to have_link t('sessions.signin')
      expect(page).to_not have_link t('sessions.signout')
    end
  end
end

RSpec.describe 'Host profile creation' do
  let!(:klass) { Host }

  it_behaves_like 'A user profile creation'
end

RSpec.describe 'Host profile creation' do
  let!(:klass) { Volunteer }

  it_behaves_like 'A user profile creation'
end

RSpec.describe 'User profile page' do
  let!(:profile) do
    create(:host,
           :with_language,
           description: 'My website: http://mywebsite.example.com',
           availability: %w(feb))
  end

  before { visit user_path(profile) }

  it 'correctly handles links in profile description' do
    expect(page).to have_link('http://mywebsite.example.com')
  end

  it 'has the user name in the title' do
    expect(page).to have_title profile.name
  end

  it 'has the user location' do
    expect(page).to have_content(profile.region.name)
    expect(page).to have_content(profile.region.country.name)
  end

  it 'has the user language' do
    line = "#{Language.first.name} (#{LanguageSkill.first.level.titleize})"

    expect(page).to have_content(line)
  end

  it 'has the user description' do
    expect(page).to have_content(profile.description)
  end

  it 'has all received feedback' do
    profile.received_feedbacks.each do |f|
      expect(page).to have_content(f.content)
    end
  end

  it 'has the count of received feedback' do
    expect(page).to have_content(profile.received_feedbacks.count)
  end

  it 'has all sent feedback' do
    profile.sent_feedbacks.each { |f| expect(page).to have_content(f.content) }
  end

  it 'has the count of sent feedback' do
    expect(page).to have_content(profile.sent_feedbacks.count)
  end

  it 'has all of user worktypes' do
    profile.work_types.each { |wt| expect(page).to have_content(wt.name) }
  end

  it 'has correct user availability' do
    marks = User::AVAILABILITY.map { |m| profile.available_in?(m) ? '✔' : '✘' }

    expect(page).to have_content(marks.join)
  end

  it 'shows new user profile' do
    expect(page).to have_title profile.name
  end
end

#
# TODO: Add tests for geographical filters
#
RSpec.describe 'User profile index' do
  let!(:host_available) { create(:host, :available_just_now) }
  let!(:host_not_available) { create(:host, :not_available) }
  let!(:vol_available) { create(:volunteer, :available_just_now) }
  let!(:vol_not_available) { create(:volunteer, :not_available) }

  before { visit users_path }

  it 'lists all profiles' do
    User.all.each do |user|
      expect(page).to have_selector('li', text: user.name)
    end
  end

  describe 'available profiles' do
    before { click_link t('users.filters.now') }

    describe 'filtering' do
      it 'shows correct list' do
        expect(page).to have_selector('li', text: host_available.name)
        expect(page).to have_selector('li', text: vol_available.name)
        expect(page).not_to have_selector('li', text: host_not_available.name)
        expect(page).not_to have_selector('li', text: vol_not_available.name)
      end
    end

    describe 'unfiltering' do
      before { click_link t('users.filters.whenever') }

      it 'shows correct list' do
        expect(page).to have_selector('li', text: host_available.name)
        expect(page).to have_selector('li', text: vol_available.name)
        expect(page).to have_selector('li', text: host_not_available.name)
        expect(page).to have_selector('li', text: vol_not_available.name)
      end
    end
  end

  describe 'host profiles' do
    before { click_link t('users.filters.hosts') }

    describe 'filtering' do
      it 'shows correct list' do
        expect(page).to have_selector('li', text: host_available.name)
        expect(page).not_to have_selector('li', text: vol_available.name)
        expect(page).to have_selector('li', text: host_not_available.name)
        expect(page).not_to have_selector('li', text: vol_not_available.name)
      end
    end

    describe 'unfiltering' do
      before { click_link t('users.filters.all') }

      it 'shows correct list' do
        expect(page).to have_selector('li', text: host_available.name)
        expect(page).to have_selector('li', text: vol_available.name)
        expect(page).to have_selector('li', text: host_not_available.name)
        expect(page).to have_selector('li', text: vol_not_available.name)
      end
    end
  end

  describe 'volunteer profiles' do
    before { click_link t('users.filters.volunteers') }

    describe 'filtering' do
      it 'shows correct list' do
        expect(page).not_to have_selector('li', text: host_available.name)
        expect(page).to have_selector('li', text: vol_available.name)
        expect(page).not_to have_selector('li', text: host_not_available.name)
        expect(page).to have_selector('li', text: vol_not_available.name)
      end
    end

    describe 'unfiltering' do
      before { click_link t('users.filters.all') }

      it 'shows correct list' do
        expect(page).to have_selector('li', text: host_available.name)
        expect(page).to have_selector('li', text: vol_available.name)
        expect(page).to have_selector('li', text: host_not_available.name)
        expect(page).to have_selector('li', text: vol_not_available.name)
      end
    end
  end

  describe 'mixed filters' do
    before do
      click_link t('users.filters.hosts')
      click_link t('users.filters.now')
    end

    it 'shows correct list' do
      expect(page).to have_selector('li', text: host_available.name)
      expect(page).not_to have_selector('li', text: vol_available.name)
      expect(page).not_to have_selector('li', text: host_not_available.name)
      expect(page).not_to have_selector('li', text: vol_not_available.name)
    end
  end
end

RSpec.describe 'User profile editing' do
  let(:host) { create(:host, email: 'old_email@example.com') }
  let(:update_user) { t('helpers.submit.user.update', model: User) }

  before do
    visit root_path
    sign_in host
    visit edit_user_registration_path
  end

  it 'shows edit page' do
    expect(page).to have_title t('users.edit.title')
  end

  context 'with invalid information' do
    before do
      fill_in 'user[email]', with: 'invalid@example'
      click_button update_user
    end

    it 'shows an error field' do
      expect(page).to have_selector '.has-error'
    end
  end

  context 'with nothing introduced' do
    before { click_button update_user }

    it 'shows a success flash message' do
      expect(page).to \
        have_flash_message t('devise.registrations.updated'), 'success'
    end
  end

  context 'with valid information' do
    before do
      fill_in 'user[email]', with: 'new_email@example.com'
      click_button update_user
    end

    it 'shows a success flash message' do
      msg = t('devise.registrations.update_needs_confirmation')

      expect(page).to have_flash_message msg, 'success'
    end

    it 'shows a logout link' do
      expect(page).to \
        have_link t('sessions.signout'), href: destroy_user_session_path
    end

    it 'updates hosts unconfirmed_email correctly' do
      expect(host.reload.email).to eq('old_email@example.com')
      expect(host.reload.unconfirmed_email).to eq('new_email@example.com')
    end

    it 'redirects back to user profile' do
      expect(current_path).to eq(user_path(host))
    end
  end
end
