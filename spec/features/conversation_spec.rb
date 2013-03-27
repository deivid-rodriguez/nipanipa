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
    page.find("#offer-#{host.offers.first.id}").click_link new_conversation_lnk
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
#feature "Editing feedbacks" do
#  given!(:feedback) { create(:feedback) }
#  given(:feedback_btn) { t('helpers.submit.feedback.update') }
#
#  background do
#    sign_in feedback.sender
#    page.find("#feedback-#{feedback.id}").click_link('Editar')
#  end
#
#  scenario "with invalid information" do
#    fill_in "feedback_content", with: "a" * 301
#    click_button feedback_btn
#
#    feedback.reload.content.should_not == "a" * 301
#    page.should have_flash_message t('feedbacks.update.error'), 'error'
#  end
#
#  scenario "with valid information" do
#    fill_in 'feedback_content', with: "New opinion"
#    click_button feedback_btn
#
#    feedback.reload.content.should == "New opinion"
#    page.should have_selector 'h1', text: feedback.sender.name
#    page.should have_flash_message t('feedbacks.update.success'), 'success'
#  end
#
#end

