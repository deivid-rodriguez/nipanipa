# frozen_string_literal: true

RSpec.describe "Listing user conversations" do
  let!(:message) { create(:message) }

  before do
    mock_sign_in(message.sender)
    visit user_path(message.sender)
    click_link t("shared.profile_header.messages")
  end

  it "properly lists user conversations" do
    expect(page).to have_content message.body
    expect(page).to have_link message.recipient.name
    expect(page).not_to have_link message.sender.name
  end
end

RSpec.describe "Display a conversation" do
  let!(:message) { create(:message) }

  before do
    mock_sign_in(message.sender)
    visit conversations_path

    click_link("show-link-#{message.recipient.id}")
    expect(page).to have_selector('#message_body')
  end

  it "lists all messages between the users" do
    expect(page).to have_content(message.body)
  end

  it "changes page title to include the contact" do
    expect(page).to have_title("Messages with #{message.recipient.name}")
  end

  it "shows a new message box" do
    expect(page).to have_button t("helpers.submit.message.create")
  end

  describe "and reply to it", :js do
    context "successfully" do
      before { reply("This is a sample reply") }

      it "shows the message just replied" do
        expect(page).to have_content "This is a sample reply"
      end

      it "sends_notification email" do
        expect(sent_emails.size).to eq(1)
        expect(last_email.to).to include(message.recipient.email)
      end

      it "shows a success message" do
        have_flash_message t("conversations.update.ok"), "success"
      end
    end

    context "unsuccessfully" do
      before { reply("") }

      it "shows an error message and keeps user in the same page" do
        expect(page).to \
          have_flash_message t("conversations.update.error"), "danger"

        expect(page).to have_button t("helpers.submit.message.create")
      end
    end
  end
end

RSpec.describe "Delete a conversation", :js do
  let!(:message) { create(:message) }
  let(:recipient) { message.recipient }
  let(:sender) { message.sender }

  before do
    mock_sign_in(sender)
    visit conversations_path
    find_link("delete-link-#{recipient.id}").trigger("click")
  end

  it "removes conversation from list" do
    expect(page).not_to have_selector "li#conversation-preview-#{recipient.id}"
  end

  context "when the other user goes to message list" do
    before do
      click_link t("sessions.signout")
      sign_in(recipient) # TODO: mock_sign_in is not working here... :(
      visit conversations_path
    end

    it "conversation should still be there" do
      expect(page).to have_selector "li#conversation-preview-#{sender.id}"
    end

    context "and deletes the same conversation" do
      it "is also removed from database" do
        find_link("delete-link-#{sender.id}").trigger("click")

        expect(page).not_to have_selector "li#conversation-preview-#{sender.id}"
        expect(Message.count).to eq(0)
      end
    end
  end
end
