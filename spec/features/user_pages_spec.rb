# frozen_string_literal: true

#
# Integration tests for User pages
#
RSpec.shared_examples_for 'a nipanipa user' do
  let(:role) { klass.name.underscore }
  let!(:user) { build(role.to_sym) }

  describe 'Profile Creation' do
    let(:create_btn) { t('helpers.submit.user.create') }
    let!(:region) { create(:region) }
    let!(:l) { create(:language) }
    let!(:work_type) { create(:work_type) }

    before { visit send(:"#{role}_registration_path") }

    it 'shows correct header' do
      role_i18n = t("activerecord.models.#{role}")
      header = t('users.new.header', type: role_i18n).titleize

      expect(page).to have_selector 'h1', text: header
    end

    it 'shows correct page title' do
      expect(page).to have_title full_title(t('users.new.title'))
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
        within '.user-form' do
          fill_in 'user[name]', with: user.name
          fill_in 'user[email]', with: user.email
          fill_in 'user[password]', with: user.password
          fill_in 'user[password_confirmation]', with: user.password
          fill_in 'user[description]', with: user.description
          select l.name, from: 'user_language_skills_attributes_0_language_id'
          select 'Expert', from: 'user_language_skills_attributes_0_level'
          check "user_work_type_ids_#{work_type.id}"
          check 'user_availability_2'
        end

        expect { click_button create_btn }.to change(klass, :count).by(1)
      end

      it 'shows a success flash message' do
        expect(page).to have_flash_message \
          t('devise.registrations.signed_up_but_unconfirmed'), 'success'
      end

      it 'does not login the unconfirmed user' do
        expect(page).to_not have_link t('sessions.signout')
      end

      it 'redirects the unconfirmed user to the sign in page' do
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end

  describe 'Profile edition' do
    let(:update_user) { t('helpers.submit.user.update', model: User) }

    before do
      user.save
      visit root_path
      sign_in user
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

    describe 'changing user email' do
      before do
        user.update_column(:email, 'old_email@example.com')
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
        expect(user.reload.email).to eq('old_email@example.com')
        expect(user.reload.unconfirmed_email).to eq('new_email@example.com')
      end

      it 'redirects back to user profile' do
        expect(current_path).to eq(user_path(user))
      end
    end
  end
end

RSpec.describe 'Hosts' do
  let!(:klass) { Host }

  it_behaves_like 'a nipanipa user'
end

RSpec.describe 'Volunteers' do
  let!(:klass) { Volunteer }

  it_behaves_like 'a nipanipa user'
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
    marks = (1..12).map { |m| profile.available_in?(m) ? '✔' : '✘' }

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

  shared_examples_for 'a list of available profiles' do
    it 'lists only available profiles' do
      expect(page).to have_selector('li', text: host_available.name)
      expect(page).to have_selector('li', text: vol_available.name)
      expect(page).not_to have_selector('li', text: host_not_available.name)
      expect(page).not_to have_selector('li', text: vol_not_available.name)
    end
  end

  shared_examples_for 'a list of available hosts' do
    it 'lists only available hosts' do
      expect(page).to have_selector('li', text: host_available.name)
      expect(page).not_to have_selector('li', text: vol_available.name)
      expect(page).not_to have_selector('li', text: host_not_available.name)
      expect(page).not_to have_selector('li', text: vol_not_available.name)
    end
  end

  shared_examples_for 'a list of available volunteers' do
    it 'lists only available volunteers' do
      expect(page).not_to have_selector('li', text: host_available.name)
      expect(page).to have_selector('li', text: vol_available.name)
      expect(page).not_to have_selector('li', text: host_not_available.name)
      expect(page).not_to have_selector('li', text: vol_not_available.name)
    end
  end

  def apply_filter(name)
    visit users_path
    click_link t("users.filters.#{name}")
  end

  describe 'anonymous defaults' do
    before { visit users_path }

    it_behaves_like 'a list of available profiles'
  end

  describe 'volunteer defaults' do
    before do
      mock_sign_in vol_available
      visit users_path
    end

    it_behaves_like 'a list of available hosts'
  end

  describe 'host defaults' do
    before do
      mock_sign_in host_available
      visit users_path
    end

    it_behaves_like 'a list of available volunteers'
  end

  describe 'available now' do
    before { apply_filter('now') }

    it_behaves_like 'a list of available profiles'
  end

  describe 'available whenever' do
    before { apply_filter('whenever') }

    it 'shows correct list' do
      expect(page).to have_selector('li', text: host_available.name)
      expect(page).to have_selector('li', text: vol_available.name)
      expect(page).to have_selector('li', text: host_not_available.name)
      expect(page).to have_selector('li', text: vol_not_available.name)
    end
  end

  describe 'host profiles' do
    before { apply_filter('host') }

    it_behaves_like 'a list of available hosts'
  end

  describe 'all profiles' do
    before { apply_filter('user') }

    it_behaves_like 'a list of available profiles'
  end

  describe 'volunteer profiles' do
    before { apply_filter('volunteer') }

    it_behaves_like 'a list of available volunteers'
  end

  describe 'mixed filters' do
    before do
      visit users_path
      click_link t('users.filters.host')
      click_link t('users.filters.whenever')
    end

    it 'shows correct list' do
      expect(page).to have_selector('li', text: host_available.name)
      expect(page).not_to have_selector('li', text: vol_available.name)
      expect(page).to have_selector('li', text: host_not_available.name)
      expect(page).not_to have_selector('li', text: vol_not_available.name)
    end
  end
end

RSpec.describe 'User profile deletion' do
  let(:volunteer) { create(:volunteer) }
  let(:host) { create(:host, :with_pictures) }

  def create_sample_messages
    create(:message, sender: host, recipient: volunteer)
    create(:message, sender: volunteer, recipient: host)
  end

  def create_sample_feedback
    create(:feedback, sender: host, recipient: volunteer)
    create(:feedback, sender: volunteer, recipient: host)
  end

  before do
    create_sample_messages
    create_sample_feedback

    visit root_path
    sign_in host
    click_link t('shared.profile_header.delete')
  end

  it 'shows confirmation page' do
    expect(page).to have_title t('users.delete.title')
  end

  context 'when confirmed' do
    before { click_button t('users.delete.title') }

    it 'deletes the user account' do
      expect(User.count).to eq(1)
    end

    it 'deletes all user pictures' do
      expect(Picture.count).to eq(0)
    end

    it 'deletes all user messages' do
      expect(Message.count).to eq(0)
    end

    it 'deletes all user feedback' do
      expect(Feedback.count).to eq(0)
    end

    it 'redirects back to user list' do
      expect(current_path).to eq(users_path)
    end
  end
end
