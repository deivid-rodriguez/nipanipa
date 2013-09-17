#
# Integration tests for Feedback pages
#

describe 'Leaving feedback' do
  let!(:feedback)        { build(:feedback)                        }
  let(:new_feedback_lnk) { t('shared.profile_header.new_feedback') }

  subject { page }

  describe '"new feedback" link' do
    before { visit user_path(feedback.recipient) }

    context 'when visitor not signed in' do
      it { should_not have_link new_feedback_lnk }
    end

    context 'when visitor signed in' do
      before { mock_sign_in feedback.sender }

      context 'and looking at own profile' do
        it { should_not have_link new_feedback_lnk }
      end

      context 'and looking at other profile' do
        before { visit user_path(feedback.recipient) }
        it { should have_link new_feedback_lnk }
      end
    end
  end

  context 'workflow' do
    let(:feedback_btn) { t('helpers.submit.feedback.create') }

    before do
      Capybara.current_driver = :mechanize
      mock_sign_in feedback.sender
      visit user_path(feedback.recipient)
      click_link new_feedback_lnk
    end

    after { Capybara.use_default_driver }

    context 'with incomplete information' do
      before { click_button feedback_btn }

      it "doesn't save a feedback in db" do
        Donation.count.should == 0
        Feedback.count.should == 0
      end

      it { should have_flash_message t('feedbacks.create.error'), 'error' }

      it "doesn't update recipient's karma" do
        feedback.recipient.karma.should eq(0)
      end
    end

    context 'with valid information and no donation' do
      before do
        choose  'feedback_score_positive'
        fill_in 'feedback[content]', with: feedback.content
        click_button feedback_btn
      end

      it "correctly updates db" do
        Donation.count.should == 0
        Feedback.count.should == 1
        feedback.recipient.reload.karma.should eq(1)
      end

      it { should have_content feedback.content }
      it { should have_link t('shared.edit') }
      it { should have_selector 'h3', text: feedback.recipient.name }
      it { should have_flash_message t('feedbacks.create.success'), 'success' }
    end

    context 'with valid information and donation' do
      before do
        choose  'feedback_score_positive'
        fill_in 'feedback[content]', with: feedback.content
        fill_in 'feedback[donation_attributes][amount]', with: 20
        click_button feedback_btn
        mock_paypal_pdt('SUCCESS', Donation.last.id)
      end

      it 'correctly updates db' do
        Donation.count.should == 1
        Feedback.count.should == 1
        feedback.recipient.karma.should eq(0)
      end

      it { should have_content feedback.content }
      it { should have_link t('shared.edit') }
      it { should have_selector 'h3', text: feedback.recipient.name }
      it { should have_flash_message t('donations.create.success'), 'success' }
    end
  end
end

describe 'Editing feedbacks' do
  let!(:feedback)    { create(:feedback, score: :positive) }
  let(:feedback_btn) { t('helpers.submit.feedback.update') }

  subject { page }

  before do
    Capybara.current_driver = :mechanize
    mock_sign_in feedback.sender
    page.find("#feedback-#{feedback.id}").click_link(t('shared.edit'))
  end

  after { Capybara.use_default_driver }

  context 'with invalid information' do
    before do
      fill_in 'feedback[content]', with: 'a' * 301
      click_button feedback_btn
    end

    it 'does not get updated with new content' do
      expect(feedback.reload.content).not_to eq('a' * 301)
    end
    it { should have_flash_message t('feedbacks.update.error'), 'error' }
  end

  context 'with valid information and no donation' do
    before do
      fill_in 'feedback_content', with: 'New really bad opinion'
      choose  'feedback_score_negative'
      click_button feedback_btn
    end

    it 'gets updated with the new content' do
      expect(feedback.reload.content).to eq('New really bad opinion')
      Donation.count.should == 0
      Feedback.count.should == 1
      feedback.recipient.reload.karma.should eq(-1)
    end

    it { should have_selector 'h3', text: feedback.sender.name }
    it { should have_flash_message t('feedbacks.update.success'), 'success' }
  end

  context 'with valid information and donation' do
    before do
      fill_in 'feedback[donation_attributes][amount]', with: 20
      click_button feedback_btn
      mock_paypal_pdt('SUCCESS', Donation.last.id)
    end

    it 'correctly updates db' do
      Donation.count.should == 1
      Feedback.count.should == 1
      feedback.recipient.karma.should eq(1)
    end

    it { should have_selector 'h3', text: feedback.recipient.name }
    it { should have_flash_message t('donations.create.success'), 'success' }
  end
end

describe 'Listing feedbacks' do
  let!(:feedbacks) { create_list(:feedback, 3, recipient: create(:host)) }

  subject { page }

  shared_examples 'feedback list' do
    it { should have_selector 'li', text: feedbacks[0].content }
    it { should have_selector 'li', text: feedbacks[1].content }
    it { should have_selector 'li', text: feedbacks[2].content }
  end

  context 'when listing received feedbacks' do
    before { mock_sign_in feedbacks[0].recipient }

    context 'in main profile view' do
      it { should have_selector 'h3', text: t('users.show.feedback') }
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
      it { should have_selector 'h3', text: t('users.show.feedback') }
      it_behaves_like 'feedback list'
    end

    context 'in feedbacks tab' do
      before { click_link t('users.show.feedback') }
      it_behaves_like 'feedback list'
    end
  end
end

describe 'Destroying feedbacks' do
  let!(:feedback)  { create(:feedback, score: :positive) }
  let!(:recipient) { feedback.recipient }

  subject { page }

  before do
    mock_sign_in feedback.sender
    page.find("#feedback-#{feedback.id}").click_link(t('shared.delete'))
  end

  context 'successfully' do
    it 'updates recipients karma and feedback count' do
      Feedback.count.should == 0
      recipient.reload.karma.should eq(0)
    end
    it { should have_selector 'h3', text: feedback.sender.name }
    it { should_not have_css "div#feedback-#{feedback.id}" }
    it { should have_flash_message t('feedbacks.destroy.success'), 'success' }
  end

end
