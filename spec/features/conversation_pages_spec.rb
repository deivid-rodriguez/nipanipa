#
# Integration tests for Conversation pages
#

describe 'Create a conversation' do
  let!(:host)           { create(:host, :with_offers) }
  let!(:volunteer)      { create(:volunteer) }
  let(:conversation)    { build(:conversation, from: volunteer, to: host) }
  let(:new_conv_lnk)    { t('offers.offer.contact') }
  let(:create_conv_btn) { t('helpers.submit.conversation.create') }

  before do
    sign_in volunteer
    visit user_path(host)
  end

  # XXX: Add extra functionality when associated to offer
  context 'regarding an offer' do
    before do
      within("#offer-#{host.offers.first.id}") { click_link new_conv_lnk }
    end

    it 'works with invalid information' do
      expect { click_button create_conv_btn }.
        not_to change(Conversation, :count)
      page.should have_flash_message t('conversations.create.error'), 'error'
    end

    it 'works with valid information' do
      fill_in 'conversation[subject]', with: conversation.subject
      fill_in 'conversation[messages_attributes][0][body]',
              with: conversation.messages.first.body
      expect { click_button create_conv_btn }.
        to change(Conversation, :count).by(1)
      page.should \
        have_flash_message t('conversations.create.success'), 'success'
    end
  end

  context 'not regarding an offer' do
    before do
      within('.nav-list') { click_link t('layouts.sidebar.new_conversation') }
    end

    it 'works with invalid information' do
      expect { click_button create_conv_btn }.
        not_to change(Conversation, :count)
      page.should have_flash_message t('conversations.create.error'), 'error'
    end

    it 'works with valid information' do
      fill_in 'conversation[subject]', with: conversation.subject
      fill_in 'conversation[messages_attributes][0][body]',
              with: conversation.messages.first.body
      expect { click_button create_conv_btn }.
        to change(Conversation, :count).by(1)
      page.should \
        have_flash_message t('conversations.create.success'), 'success'
    end
  end

end

describe 'Listing user conversations' do
  let!(:conversation) { create(:conversation) }

  before do
    sign_in conversation.from
    click_link t('layouts.sidebar.show_conversations')
  end

  it 'properly lists user conversations' do
    page.should have_content conversation.subject
  end
end

describe 'Display a conversation' do
  let!(:conversation) { create(:conversation) }

  before do
    sign_in conversation.from
    visit user_conversations_path(conversation.from)
    within("#conversation-preview-#{conversation.id}") do
      click_link conversation.subject
    end
  end

  it 'lists all messages in thread' do
    page.should have_content conversation.messages.first.body
  end

  it 'shows a reply box' do
    page.should have_title conversation.subject
    page.should have_selector 'h1', text: conversation.subject
    page.should have_button t('conversations.show.reply')
  end

  describe 'and reply to it', :js do

    context 'successfully' do
      before { reply('This is a sample body') }

      it 'shows the message just replied' do
        page.should have_content 'This is a sample body'
      end
    end

    context 'unsuccessfully' do
      before { reply('') }

      it 'shows an error message and keeps user in the same page' do
        page.should have_flash_message t('conversations.reply.error'), 'error'
        page.should have_button t('conversations.show.reply')
      end
    end
  end

end

describe 'User deletes a conversation', :js do
  let!(:conversation) { create(:conversation) }

  before do
    sign_in conversation.from
    visit user_conversations_path(conversation.from)
    page.driver.accept_js_confirms!
    click_link "delete-link-#{conversation.id}"
  end

  it 'removes conversation from list' do
    page.should_not have_selector "li#conversation-preview-#{conversation.id}"
  end

  context 'when the other user goes to message list' do
    before do
      sign_out
      sign_in conversation.to
      visit user_conversations_path(conversation.to)
    end

    it 'conversation should still be there' do
      page.should have_selector "li#conversation-preview-#{conversation.id}"
    end

    context 'and deletes the same conversation' do
      it 'is also removed from database' do
        click_link "delete-link-#{conversation.id}"
        expect { Conversation.count }.to change_by(-1)
        page.should_not have_selector \
          "li#conversation-preview-#{conversation.id}"
      end
    end

    context 'and replies to the same conversation' do
      before do
        within("#conversation-preview-#{conversation.id}") do
          click_link conversation.subject
        end
        reply('This is a sample body')
        sign_out
        sign_in conversation.from
        visit user_conversations_path(conversation.from)
      end

      it 'reappears in the first user\'s message list' do
        page.should have_selector "li#conversation-preview-#{conversation.id}"
      end
    end

  end

end
