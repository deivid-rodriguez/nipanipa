feature "Creating feedbacks" do
  given!(:user)       { create(:user) }
  given!(:other_user) { create(:user) }

  subject { page }

  background do
    sign_in user
    visit new_user_feedback_path(other_user)
  end

  scenario "with invalid information" do
    expect { click_button "Leave feedback" }.not_to change(Feedback, :count)
    page.should have_selector '.alert-error'
  end

  scenario "with valid information" do
    fill_in 'feedback_content', with: "Lorem ipsum"
    expect { click_button "Leave feedback" }.to change(Feedback, :count).by(1)
    page.should have_selector 'h1', text: other_user.name
  end
end

feature "Editing feedbacks" do
  given!(:feedback) { create(:feedback) }

  background do
    sign_in feedback.sender
    page.find("#feedback-#{feedback.id}").click_link('Editar')
  end

  scenario "with invalid information" do
    fill_in "feedback_content", with: "a" * 301
    click_button "Leave feedback"

    feedback.reload.content.should_not == "a" * 301
    page.should have_selector '.alert-error'
  end

  scenario "with valid information" do
    fill_in 'feedback_content', with: "New opinion"
    click_button "Leave feedback"

    feedback.reload.content.should == "New opinion"
    page.should have_selector 'h1', text: feedback.sender.name
  end

end

feature "Destroying feedbacks" do
  given!(:feedback) { create(:feedback) }

  background do
    sign_in feedback.sender
  end

  scenario "clicking feedback destroy should delete the feedback" do
    expect { page.find("#feedback-#{feedback.id}").click_link('Borrar')
    }.to change(Feedback, :count).by(-1)
    page.should have_selector 'h1', text: feedback.sender.name
    page.should_not have_css "div#feedback-#{feedback.id}"
  end

end
