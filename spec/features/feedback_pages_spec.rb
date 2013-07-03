#
# Integration tests for Feedback pages
#

describe 'Creating feedbacks' do
  let!(:feedback)    { build(:feedback) }
  let(:feedback_btn) { t('helpers.submit.feedback.create') }

  subject { page }

  before do
    visit root_path
    sign_in feedback.sender
    visit user_path(feedback.recipient)
    click_link t('shared.profile_header.new_feedback')
  end

  context 'with invalid information' do
    before do
      expect { click_button feedback_btn }.not_to change(Feedback, :count)
    end

    it { should have_flash_message t('feedbacks.create.error'), 'error' }
  end

  context 'with valid information' do
    before do
      fill_in 'feedback[content]', with: 'Lorem ipsum'
      choose  'feedback_score_1'
      expect { click_button feedback_btn }.to change(Feedback, :count).by(1)
    end
    it { should have_selector 'h3', text: feedback.recipient.name }
    it { should have_flash_message t('feedbacks.create.success'), 'success' }
  end
end


describe 'Editing feedbacks' do
  let!(:feedback)    { create(:feedback) }
  let(:feedback_btn) { t('helpers.submit.feedback.update') }

  subject { page }

  before do
    visit root_path
    sign_in feedback.sender
    page.find("#feedback-#{feedback.id}").click_link('Editar')
  end

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

  context 'with valid information' do
    before do
      fill_in 'feedback_content', with: 'New opinion'
      click_button feedback_btn
    end

    it 'gets updated with the new content' do
      expect(feedback.reload.content).to eq('New opinion')
    end
    it { should have_selector 'h3', text: feedback.sender.name }
    it { should have_flash_message t('feedbacks.update.success'), 'success' }
  end

end

describe 'Listing feedbacks' do
  let!(:feedbacks) { create_list(:feedback, 3, recipient: create(:host)) }

  subject { page }

  before { visit root_path }

  shared_examples 'feedback list' do
    it { should have_selector 'li', text: feedbacks[0].content }
    it { should have_selector 'li', text: feedbacks[1].content }
    it { should have_selector 'li', text: feedbacks[2].content }
  end

  context 'when listing received feedbacks' do
    before { sign_in feedbacks[0].recipient }

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
    before { sign_in feedbacks[0].sender }

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
  let!(:feedback) { create(:feedback) }

  subject { page }

  before do
    visit root_path
    sign_in feedback.sender
    expect { page.find("#feedback-#{feedback.id}").click_link('Borrar') }.
      to change(Feedback, :count).by(-1)

  end

  context 'successfully' do
    it { should have_selector 'h3', text: feedback.sender.name }
    it { should_not have_css "div#feedback-#{feedback.id}" }
    it { should have_flash_message t('feedbacks.destroy.success'), 'success' }
  end

end
