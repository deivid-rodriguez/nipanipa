#
# Integration tests for Conversation pages
#

feature "Creating conversations" do
  given!(:host)                   { create(:host, :with_offers) }
  given!(:volunteer)              { create(:volunteer) }
  given!(:conversation)           { build(:conversation,
                                          from: volunteer, to: host) }
  given(:new_conversation_lnk)    { t('offers.offer.contact') }
  given(:create_conversation_btn) { t('helpers.submit.conversation.create') }

  background do
    sign_in volunteer
    visit user_path(host)
    within("#offer-#{host.offers.first.id}") { click_link new_conversation_lnk }
  end

  scenario "with invalid information" do
    expect { click_button create_conversation_btn
    }.not_to change(Conversation, :count)
    page.should have_flash_message t('conversations.create.error'), 'error'
  end

  scenario "with valid information" do
    fill_in 'conversation[subject]', with: conversation.subject
    fill_in 'conversation[messages_attributes][0][body]',
            with: conversation.messages.first.body
    expect { click_button create_conversation_btn
    }.to change(Conversation, :count).by(1)
    page.should have_flash_message t('conversations.create.success'), 'success'
  end
end

feature "Listing user conversations" do
  given!(:host)                   { create(:host, :with_offers) }
  given!(:volunteer)              { create(:volunteer) }
  given!(:conversation)           { create(:conversation,
                                          from: volunteer, to: host) }

  background do
    sign_in volunteer
    visit user_path(host)
    click_link t('layouts.sidebar.show_conversations')
  end

  scenario "user conversations should be listed" do
    page.should have_content conversation.subject
  end
end

feature "Display a conversation" do
  given!(:conversation) { create(:conversation) }

  background do
    sign_in conversation.from
    visit user_conversations_path(conversation.from)
    find(:xpath,
     "//a[@href='#{user_conversation_path(conversation.from, conversation)}']").
     click
  end

  scenario "All messages in thread are listed" do
    page.should have_content conversation.messages.first.body
  end

  scenario "A reply box is shown" do
    page.should have_title conversation.subject
    page.should have_selector 'h1', text: conversation.subject
    page.should have_button t('conversations.show.reply')
  end
end
