#
# Integration tests for Feedback pages
#
RSpec.describe 'Leaving feedback', :with_fake_paypal do
  let!(:feedback) { build(:feedback) }
  let(:feedback_btn) { t('helpers.submit.feedback.create') }

  before do
    mock_sign_in(feedback.sender)
    visit user_path(feedback.recipient)
    click_link t('shared.profile_header.new_feedback')
  end

  context 'with incomplete information' do
    before { click_button feedback_btn }

    it "doesn't save a feedback in db" do
      expect(Donation.count).to eq(0)
      expect(Feedback.count).to eq(0)
    end

    it 'shows an error flash message' do
      expect(page).to \
        have_flash_message t('feedbacks.create.error'), 'danger'
    end

    it "doesn't update recipient's karma" do
      expect(feedback.recipient.karma).to eq(0)
    end
  end

  context 'with valid information and no donation' do
    before do
      choose 'feedback_score_positive'
      fill_in 'feedback[content]', with: feedback.content
      click_button feedback_btn
    end

    it 'correctly updates db' do
      expect(Donation.count).to eq(0)
      expect(Feedback.count).to eq(1)
      expect(feedback.recipient.reload.karma).to eq(1)
    end

    it 'shows feedback text' do
      expect(page).to have_content feedback.content
    end

    it 'shows edit link' do
      expect(page).to have_link t('shared.edit')
    end

    it 'goes back to previous page' do
      expect(page).to have_selector 'h3', text: feedback.recipient.name
    end

    it 'shows a success flash message' do
      expect(page).to \
        have_flash_message t('feedbacks.create.success'), 'success'
    end
  end

  context 'with valid information and donation' do
    before do
      choose 'feedback_score_positive'
      fill_in 'feedback[content]', with: feedback.content
      select '20', from: 'feedback[donation_attributes][amount]'
      click_button feedback_btn
    end

    it 'correctly updates db' do
      expect(Donation.count).to eq(1)
      expect(Feedback.count).to eq(1)
      expect(feedback.recipient.karma).to eq(0)
    end

    it 'shows feedback text' do
      expect(page).to have_content feedback.content
    end

    it 'shows edit link' do
      expect(page).to have_link t('shared.edit')
    end

    it 'returns to previous page' do
      expect(page).to have_selector 'h3', text: feedback.recipient.name
    end

    it 'shows a success flash message' do
      expect(page).to \
        have_flash_message t('donations.create.success'), 'success'
    end
  end
end

RSpec.describe 'Editing feedbacks' do
  let!(:feedback) { create(:feedback, score: :positive) }
  let(:feedback_btn) { t('helpers.submit.feedback.update') }

  before do
    mock_sign_in(feedback.sender)
    visit user_path(feedback.sender)
    page.find("#feedback-#{feedback.id}").click_link(t('shared.edit'))
  end

  context 'with invalid information' do
    before do
      fill_in 'feedback[content]', with: 'a' * 301
      click_button feedback_btn
    end

    it 'does not get updated with new content' do
      expect(feedback.reload.content).not_to eq('a' * 301)
    end

    it 'shows an error flash message' do
      expect(page).to have_flash_message t('feedbacks.update.error'), 'danger'
    end
  end

  context 'with valid information and no donation' do
    before do
      fill_in 'feedback_content', with: 'New really bad opinion'
      choose 'feedback_score_negative'
      click_button feedback_btn
    end

    it 'gets updated with the new content' do
      expect(feedback.reload.content).to eq('New really bad opinion')
      expect(Donation.count).to eq(0)
      expect(Feedback.count).to eq(1)
      expect(feedback.recipient.reload.karma).to eq(-1)
    end

    it 'goes back to previous page' do
      expect(page).to have_selector 'h3', text: feedback.sender.name
    end

    it 'shows a success flash message' do
      expect(page).to \
        have_flash_message t('feedbacks.update.success'), 'success'
    end
  end

  context 'with valid information and donation', :with_fake_paypal do
    before do
      select '20', from: 'feedback[donation_attributes][amount]'
      click_button feedback_btn
    end

    it 'correctly updates db' do
      expect(Donation.count).to eq(1)
      expect(Feedback.count).to eq(1)
      expect(feedback.recipient.karma).to eq(1)
    end

    it 'goes back to previous page' do
      expect(page).to have_selector 'h3', text: feedback.sender.name
    end

    it 'shows a success flash message' do
      expect(page).to \
        have_flash_message t('donations.create.success'), 'success'
    end
  end
end

RSpec.describe 'Listing feedbacks' do
  let!(:feedback) { create(:feedback, recipient: create(:host)) }

  shared_examples_for 'feedback list' do
    it 'displays feedback content' do
      expect(page).to have_selector 'li', text: feedback.content
    end
  end

  context 'when listing received feedbacks' do
    before do
      mock_sign_in(feedback.recipient)
      visit user_path(feedback.recipient)
    end

    context 'in main profile view' do
      it 'shows feedback box' do
        expect(page).to have_selector 'h3', text: t('users.show.feedback')
      end

      it_behaves_like 'feedback list'
    end

    context 'in feedbacks tab' do
      before { click_link t('users.show.feedback') }

      it_behaves_like 'feedback list'
    end
  end

  context 'when listing sent feedbacks' do
    before do
      mock_sign_in(feedback.sender)
      visit user_path(feedback.sender)
    end

    context 'in main profile view' do
      it 'shows feedback box' do
        expect(page).to have_selector 'h3', text: t('users.show.feedback')
      end

      it_behaves_like 'feedback list'
    end

    context 'in feedbacks tab' do
      before { click_link t('users.show.feedback') }

      it_behaves_like 'feedback list'
    end
  end
end

RSpec.describe 'Destroying feedbacks' do
  let!(:feedback) { create(:feedback, score: :positive) }
  let!(:recipient) { feedback.recipient }

  before do
    mock_sign_in(feedback.sender)
    visit user_path(feedback.sender)
    page.find("#feedback-#{feedback.id}").click_link(t('shared.delete'))
  end

  context 'successfully' do
    it 'updates recipients karma and feedback count' do
      expect(Feedback.count).to eq(0)
      expect(recipient.reload.karma).to eq(0)
    end

    it 'shows senders name' do
      expect(page).to have_selector 'h3', text: feedback.sender.name
    end

    it 'does not show deleted feedback' do
      expect(page).not_to have_css "div#feedback-#{feedback.id}"
    end

    it 'shows a success flash message' do
      expect(page).to \
        have_flash_message t('feedbacks.destroy.success'), 'success'
    end
  end
end
