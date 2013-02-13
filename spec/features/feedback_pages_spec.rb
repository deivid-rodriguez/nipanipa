require 'spec_helper'

feature "Creating feedbacks" do
  given!(:user)       { create(:user) }
  given!(:other_user) { create(:user) }

  subject { page }

  background do
    sign_in user
    visit new_user_feedback_path(other_user)
  end

  # Check why it gives "You already gave feedback to that user..."
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
