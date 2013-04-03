#
# Integration tests for Conversation pages
#

describe "Creating conversations" do
  let!(:host)                   { create(:host, :with_offers) }
  let!(:volunteer)              { create(:volunteer) }
  let!(:conversation)           { build(:conversation,
                                         from: volunteer, to: host) }
  let(:new_conversation_lnk)    { t('offers.offer.contact') }
  let(:create_conversation_btn) { t('helpers.submit.conversation.create') }

  before do
    sign_in volunteer
    visit user_path(host)
  end

  # XXX: Now both cases have the same functionality, add extra when associated
  # to offer
  context "regarding an offer" do
    before do
      within("#offer-#{host.offers.first.id}") {
        click_link new_conversation_lnk }
    end

    it "works with invalid information" do
      expect { click_button create_conversation_btn
      }.not_to change(Conversation, :count)
      page.should have_flash_message t('conversations.create.error'), 'error'
    end

    it "works with valid information" do
      fill_in 'conversation[subject]', with: conversation.subject
      fill_in 'conversation[messages_attributes][0][body]',
              with: conversation.messages.first.body
      expect { click_button create_conversation_btn
      }.to change(Conversation, :count).by(1)
      page.should have_flash_message t('conversations.create.success'), 'success'
    end
  end

  describe "not regarding an offer" do
    before do
      within(".nav-list") { click_link t('layouts.sidebar.new_conversation') }
    end

    it "works with invalid information" do
      expect { click_button create_conversation_btn
      }.not_to change(Conversation, :count)
      page.should have_flash_message t('conversations.create.error'), 'error'
    end

    it "works with valid information" do
      fill_in 'conversation[subject]', with: conversation.subject
      fill_in 'conversation[messages_attributes][0][body]',
              with: conversation.messages.first.body
      expect { click_button create_conversation_btn
      }.to change(Conversation, :count).by(1)
      page.should have_flash_message t('conversations.create.success'), 'success'
    end
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

describe "Display a conversation" do
  let!(:conversation) { create(:conversation) }

  before do
    sign_in conversation.from
    visit user_conversations_path(conversation.from)
    within("#conversation-preview-#{conversation.id}") do
      click_link conversation.subject
    end
  end

  it "lists all messages in thread" do
    page.should have_content conversation.messages.first.body
  end

  it "shows a reply box" do
    page.should have_title conversation.subject
    page.should have_selector 'h1', text: conversation.subject
    page.should have_button t('conversations.show.reply')
  end

  describe "and reply to it", js: true do
    before do
      within(".message-reply") do
        fill_in "body", with: "This is a default answer"
        click_button t('conversations.show.reply')
      end
    end

    it "shows the message just replied" do
      page.should have_content 'This is a default answer'
    end
  end
end

feature "Delete a conversation" do

end
