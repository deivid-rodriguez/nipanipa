#
# Integration tests for Feedback pages
#
RSpec.describe 'Leaving feedback' do
  let!(:feedback) { build(:feedback) }
  let(:new_feedback_lnk) { t('shared.profile_header.new_feedback') }

  describe '"new feedback" link' do
    before { visit user_path(feedback.recipient) }

    context 'when visitor not signed in' do
      it 'does not show link' do
        expect(page).not_to have_link new_feedback_lnk
      end
    end

    context 'when visitor signed in' do
      before { mock_sign_in feedback.sender }

      context 'and looking at own profile' do
        it 'does not show link' do
          expect(page).not_to have_link new_feedback_lnk
        end
      end

      context 'and looking at other profile' do
        before { visit user_path(feedback.recipient) }

        it 'shows link' do
          expect(page).to have_link new_feedback_lnk
        end
      end
    end
  end

  context 'workflow' do
    let(:feedback_btn) { t('helpers.submit.feedback.create') }

    before do
      mock_sign_in feedback.sender
      visit user_path(feedback.recipient)
      click_link new_feedback_lnk
    end

    context 'with incomplete information' do
      before { click_button feedback_btn }

      it "doesn't save a feedback in db" do
        expect(Donation.count).to eq(0)
        expect(Feedback.count).to eq(0)
      end

      it 'shows an error flash message' do
        expect(page).to have_flash_message t('feedbacks.create.error'), 'error'
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

      it 'shows recipients name' do
        expect(page).to have_selector 'h3', text: feedback.recipient.name
      end

      it 'shows a success flash message' do
        expect(page).to \
          have_flash_message t('feedbacks.create.success'), 'success'
      end
    end

    context 'with valid information and donation', :js do
      before do
        choose 'feedback_score_positive'
        fill_in 'feedback[content]', with: feedback.content
        fill_in 'feedback[donation_attributes][amount]', with: 20
        click_button feedback_btn
        mock_paypal_pdt('SUCCESS', Donation.last.id)
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

      it 'shows recipients name' do
        expect(page).to have_selector 'h3', text: feedback.recipient.name
      end

      it 'shows a success flash message' do
        expect(page).to \
          have_flash_message t('donations.create.success'), 'success'
      end
    end
  end
end

RSpec.describe 'Editing feedbacks' do
  let!(:feedback)    { create(:feedback, score: :positive) }
  let(:feedback_btn) { t('helpers.submit.feedback.update') }

  before do
    mock_sign_in feedback.sender
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
      expect(page).to \
        have_flash_message t('feedbacks.update.error'), 'error'
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

    it 'shows senders name' do
      expect(page).to have_selector 'h3', text: feedback.sender.name
    end

    it 'shows a success flash message' do
      expect(page).to \
        have_flash_message t('feedbacks.update.success'), 'success'
    end
  end

  context 'with valid information and donation', :js do
    before do
      fill_in 'feedback[donation_attributes][amount]', with: 20
      click_button feedback_btn
      mock_paypal_pdt('SUCCESS', Donation.last.id)
    end

    it 'correctly updates db' do
      expect(Donation.count).to eq(1)
      expect(Feedback.count).to eq(1)
      expect(feedback.recipient.karma).to eq(1)
    end

    it 'shows recipient name' do
      expect(page).to have_selector 'h3', text: feedback.recipient.name
    end

    it 'shows a success flash message' do
      expect(page).to \
        have_flash_message t('donations.create.success'), 'success'
    end
  end
end

RSpec.describe 'Listing feedbacks' do
  let!(:feedbacks) { create_list(:feedback, 3, recipient: create(:host)) }

  shared_examples 'feedback list' do
    it 'has first feedback content' do
      expect(page).to have_selector 'li', text: feedbacks[0].content
    end

    it 'has second feedback content' do
      expect(page).to have_selector 'li', text: feedbacks[1].content
    end

    it 'has third feeback content' do
      expect(page).to have_selector 'li', text: feedbacks[2].content
    end
  end

  context 'when listing received feedbacks' do
    before { mock_sign_in feedbacks[0].recipient }

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
    before { mock_sign_in feedbacks[0].sender }

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
  let!(:feedback)  { create(:feedback, score: :positive) }
  let!(:recipient) { feedback.recipient }

  before do
    mock_sign_in feedback.sender
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
