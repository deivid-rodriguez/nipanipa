#
# Integration tests for Feedback pages
#

feature "Creating feedbacks" do
  given!(:user)        { create(:host) }
  given!(:other_user)  { create(:volunteer) }
  given(:feedback_btn) { t('helpers.submit.feedback.create') }

  background do
    visit root_path
    sign_in user
    visit new_user_feedback_path(other_user)
  end

  scenario "with invalid information" do
    expect { click_button feedback_btn }.not_to change(Feedback, :count)
    page.should have_flash_message t('feedbacks.create.error'), 'error'
  end

  scenario "with valid information" do
    fill_in 'feedback_content', with: "Lorem ipsum"
    expect { click_button feedback_btn }.to change(Feedback, :count).by(1)
    page.should have_selector 'h1', text: other_user.name
    page.should have_flash_message t('feedbacks.create.success'), 'success'
  end
end

feature "Editing feedbacks" do
  given!(:feedback) { create(:feedback) }
  given(:feedback_btn) { t('helpers.submit.feedback.update') }

  background do
    visit root_path
    sign_in feedback.sender
    page.find("#feedback-#{feedback.id}").click_link('Editar')
  end

  scenario "with invalid information" do
    fill_in "feedback_content", with: "a" * 301
    click_button feedback_btn

    feedback.reload.content.should_not == "a" * 301
    page.should have_flash_message t('feedbacks.update.error'), 'error'
  end

  scenario "with valid information" do
    fill_in 'feedback_content', with: "New opinion"
    click_button feedback_btn

    feedback.reload.content.should == "New opinion"
    page.should have_selector 'h1', text: feedback.sender.name
    page.should have_flash_message t('feedbacks.update.success'), 'success'
  end

end

feature "Destroying feedbacks" do
  given!(:feedback) { create(:feedback) }

  background do
    visit root_path
    sign_in feedback.sender
  end

  scenario "successfully" do
    expect { page.find("#feedback-#{feedback.id}").click_link('Borrar')
    }.to change(Feedback, :count).by(-1)
    page.should have_selector 'h1', text: feedback.sender.name
    page.should_not have_css "div#feedback-#{feedback.id}"
    page.should have_flash_message t('feedbacks.destroy.success'), 'success'
  end

end
