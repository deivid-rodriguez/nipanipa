#
# Integration tests for Conversation pages
#

RSpec.describe 'Create a conversation' do
  let!(:conversation) { build(:conversation) }
  let(:create_conv)  { t('helpers.submit.conversation.create') }

  before do
    mock_sign_in(conversation.from)
    visit user_path(conversation.to)
    click_link t('shared.profile_header.new_conversation')
  end

  context 'with incorrect content' do
    before do
      expect { click_button create_conv }.not_to change(Conversation, :count)
    end

    it 'shows an error message' do
      expect(page).to \
        have_flash_message t('conversations.create.error'), 'error'
    end
  end

  context 'with correct content' do
    before do
      fill_in 'conversation[subject]', with: conversation.subject
      fill_in 'conversation[messages_attributes][0][body]',
              with: conversation.messages.first.body

      expect { click_button create_conv }.to change(Conversation, :count).by(1)
    end

    it 'shows a success message' do
      expect(page).to \
        have_flash_message t('conversations.create.success'), 'success'
    end

    it { sends_notification_email(conversation.to) }
  end
end

RSpec.describe 'Listing user conversations' do
  let!(:conversation) { create(:conversation) }

  before do
    mock_sign_in(conversation.from)
    visit user_path(conversation.from)
    click_link t('shared.profile_header.conversations')
  end

  it 'properly lists user conversations' do
    expect(page).to have_content conversation.subject
    expect(page).to have_link conversation.to.name
    expect(page).not_to have_link conversation.from.name
  end
end

RSpec.describe 'Display a conversation', :js do
  let!(:conversation) { create(:conversation) }

  before do
    mock_sign_in(conversation.from)
    visit conversations_path
    find_link("show-link-#{conversation.id}").trigger('click')
  end

  it 'lists all messages in thread' do
    expect(page).to have_content conversation.messages.first.body
  end

  it 'shows a reply box' do
    expect(page).to have_title conversation.subject
    expect(page).to have_selector 'h3', text: conversation.subject
    expect(page).to have_button t('conversations.show.reply')
  end

  describe 'and reply to it' do
    context 'successfully' do
      before { reply('This is a sample reply') }

      it 'shows the message just replied' do
        expect(page).to have_content 'This is a sample reply'
      end

      it { sends_notification_email(conversation.to) }
    end

    context 'unsuccessfully' do
      before { reply('') }

      it 'shows an error message and keeps user in the same page' do
        expect(page).to \
          have_flash_message t('conversations.reply.error'), 'error'

        expect(page).to have_button t('conversations.show.reply')
      end
    end
  end
end

RSpec.describe 'Deleting conversations', :js do
  let!(:conversation) { create(:conversation) }

  before do
    mock_sign_in(conversation.from)
    visit conversations_path
    find_link("delete-link-#{conversation.id}").trigger('click')
  end

  it 'removes conversation from list' do
    expect(page).not_to \
      have_selector "li#conversation-preview-#{conversation.id}"
  end

  context 'when the other user goes to message list' do
    before do
      mock_sign_in(conversation.to)
      visit conversations_path
    end

    it 'conversation should still be there' do
      expect(page).to \
        have_selector "li#conversation-preview-#{conversation.id}"
    end

    context 'and deletes the same conversation' do
      it 'is also removed from database' do
        find_link("delete-link-#{conversation.id}").trigger('click')
        expect(page).not_to have_selector \
          "li#conversation-preview-#{conversation.id}"
        expect(Conversation.count).to eq(0)
      end
    end

    context 'and replies to the same conversation' do
      before do
        find_link("show-link-#{conversation.id}").trigger('click')
        reply('This is a sample reply')
        mock_sign_in(conversation.from)
        visit conversations_path
      end

      it 'reappears in the first user\'s message list' do
        expect(page).to \
          have_selector "li#conversation-preview-#{conversation.id}"
      end
    end
  end
end
