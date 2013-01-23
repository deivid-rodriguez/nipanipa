require 'spec_helper'

describe "FeedbackPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "feedback creation" do
    let(:other_user) { FactoryGirl.create(:user) }
    before { visit new_user_feedback_path(other_user) }

    describe "with invalid information" do
      it "should not create a micropost" do
        expect { click_button "Leave feedback" }.not_to change(Feedback, :count)
      end
      describe "error messages" do
        before { click_button "Leave feedback" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before { fill_in 'feedback_content', with: "Lorem ipsum" }
      it "should create a feedback" do
        expect { click_button "Leave feedback" }.to change(Feedback, :count).by(1)
      end
      describe "should go back to the recipient profile" do
        before { click_button "Leave feedback" }
        it { should have_selector('h1', text: other_user.name) }
      end
    end
  end

end
