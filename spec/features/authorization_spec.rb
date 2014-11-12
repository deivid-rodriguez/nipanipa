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
        let!(:feedback_by_me)  { build(:feedback, sender: user) }
        let!(:feedback_for_me) { build(:feedback, recipient: user) }

        it { is_expected.not_to have_ability(:manage, for: feedback_for_me) }
        it { is_expected.to have_ability(:manage, for: feedback_by_me) }
      end

      describe 'conversations' do
        let!(:conv_from_me) { build(:conversation, from: user) }
        let!(:conv_to_me) { build(:conversation, to: user) }

        it { is_expected.to have_ability(:manage, for: conv_from_me) }
        it { is_expected.to have_ability(:manage, for: conv_to_me) }
      end
    end
  end
end

RSpec.describe 'Protected pages' do
  let!(:user) { create(:host) }

  subject { page }

  shared_examples 'all protected pages' do
    it 'stores redirects back after log in and then forgets' do
      visit protected_page
      expect(page).to have_title t('sessions.signin')
      fill_in 'user[email]',    with: user.email
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
    let!(:feedback)  { create(:feedback, sender: user) }

    it_behaves_like 'all protected pages' do
      let(:protected_page) do
        edit_user_feedback_path(feedback.recipient, feedback)
      end
    end
  end

  describe 'new conversation page' do
    let!(:other_user) { create(:volunteer) }

    it_behaves_like 'all protected pages' do
      let(:protected_page) { new_conversation_path(other_user) }
    end
  end

  describe 'show conversation page' do
    let!(:conversation)  { create(:conversation, from: user) }

    it_behaves_like 'all protected pages' do
      let(:protected_page) { conversation_path(conversation) }
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
      before { visit new_user_registration_path(type: 'host') }
      specify { expect(current_path).to eq(user_path(user)) }
    end
  end

end
