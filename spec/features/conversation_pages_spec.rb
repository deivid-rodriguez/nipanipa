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

RSpec.describe "Display a conversation", :js do
  let!(:message) { create(:message) }

  before do
    mock_sign_in(message.sender)
    visit conversations_path

    click_link("show-link-#{message.recipient.id}")
    expect(page).to have_selector("#message_body")
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

  describe "and reply to it" do
    context "with a non-empty message" do
      before { reply("This is a sample reply") }

      it "shows the message just replied" do
        expect(page).to \
          have_selector(".message-content p", text: "This is a sample reply")
      end

      it "sends_notification email" do
        expect(sent_emails.size).to eq(1)
        expect(last_email.to).to include(message.recipient.email)
      end
    end

    context "with an empty message" do
      before { reply("") }

      it "doesn't add an empty balloon" do
        expect(page).to have_selector(".message-content p", count: 1)
      end

      it "keeps user in the same page" do
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
    accept_confirm { click_link("delete-link-#{recipient.id}") }
  end

  it "removes conversation from list" do
    expect(page).to have_no_selector "li#conversation-preview-#{recipient.id}"
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
        accept_confirm { click_link("delete-link-#{sender.id}") }

        expect(page).to have_no_selector "li#conversation-preview-#{sender.id}"
        expect(Message.count).to eq(0)
      end
    end
  end
end
