#
# Integration tests for Authentication pages
#
RSpec.describe 'User' do
  describe 'abilities' do
    subject { user }
    let(:user) { nil }

    context 'when is a regular logged in user' do
      let!(:ability) { Ability.new(user) }
      let!(:user) { create(:volunteer) }

      before do
        visit root_path
        sign_in user
      end

      describe 'feedback' do
        let!(:feedback_by_me) { build(:feedback, sender: user) }
        let!(:feedback_for_me) { build(:feedback, recipient: user) }

        it { is_expected.not_to have_ability(:manage, for: feedback_for_me) }
        it { is_expected.to have_ability(:manage, for: feedback_by_me) }
      end

      describe 'messages' do
        let!(:message_from_me) { build(:message, sender: user) }
        let!(:message_to_me) { build(:message, recipient: user) }

        it { is_expected.to have_ability(:create, for: message_from_me) }
        it { is_expected.to have_ability(:read, for: message_from_me) }

        it { is_expected.not_to have_ability(:create, for: message_to_me) }
        it { is_expected.to have_ability(:read, for: message_to_me) }
      end
    end
  end
end

RSpec.describe 'Protected pages' do
  let!(:user) { create(:host) }

  shared_examples 'all protected pages' do
    it 'stores redirects back after log in and then forgets' do
      visit protected_page
      expect(page).to have_title t('sessions.signin')
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button t('sessions.signin')
      expect(current_path).to eq(protected_page)
      click_link t('sessions.signout')
      sign_in user
      expect(page).to have_title user.name
    end
  end

  describe 'edit profile page' do
    it_behaves_like 'all protected pages' do
      let(:protected_page) { edit_user_registration_path }
    end
  end

  describe 'new feedback page' do
    let!(:other_user) { create(:volunteer) }

    it_behaves_like 'all protected pages' do
      let(:protected_page) { new_user_feedback_path(other_user) }
    end
  end

  describe 'edit feedback page' do
    let!(:feedback) { create(:feedback, sender: user) }

    it_behaves_like 'all protected pages' do
      let(:protected_page) do
        edit_user_feedback_path(feedback.recipient, feedback)
      end
    end
  end

  describe 'show conversation page' do
    before { create(:message, sender: user) }

    it_behaves_like 'all protected pages' do
      let(:protected_page) { conversation_path(id: user.id) }
    end
  end

  describe 'list conversations page' do
    it_behaves_like 'all protected pages' do
      let(:protected_page) { conversations_path }
    end
  end

  describe 'signed-in users' do
    before do
      visit root_path
      sign_in user
    end

    describe 'visiting signup page' do
      before { visit host_registration_path }

      specify { expect(current_path).to eq(user_path(user)) }
    end
  end
end
