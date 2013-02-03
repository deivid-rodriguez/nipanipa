require 'spec_helper'

feature "Signin" do

  let(:signin)  { t 'sessions.signin'    }
  let(:signout) { t 'sessions.signout'   }
  let(:profile) { t 'users.show.profile' }
  let(:user)    { create(:user)          }

  background { visit new_session_path }

  scenario "Signin page has correct content" do
    page.should have_selector 'h1', text: signin
    page.should have_title signin
  end

  scenario "with invalid information should take you back to signin page and
            show error message" do
    click_button signin

    page.should have_title signin
    page.should have_error_message('Invalid')
  end

  scenario "valid information followed by signout" do
    sign_in user

    page.should have_title user.name
    page.should have_link profile, href: user_path(user)
    page.should_not have_link signin, href: new_session_path

    click_link signout

    page.should have_link signin, href: new_session_path
    page.should_not have_link profile, href: user_path(user)
    page.should_not have_link signout
  end

end # signin

describe "authorization" do
  let(:user)       { create(:user)        }
  let(:other_user) { create(:user)        }
  let(:signin)     { t 'sessions.signin'  }
  let(:signout)    { t 'sessions.signout' }

  subject { page }

  shared_examples "all protected pages" do
    describe "back and redirect" do
      it "stores redirects back after log in and then forgets" do
        visit protected_page
        page.should have_title signin
        sign_in user
        current_path.should == protected_page
        click_link signout
        sign_in user
        page.should have_title user.name
      end
    end
  end

  describe "edit profile page" do
    it_behaves_like "all protected pages" do
      let(:protected_page) { edit_user_path(user) }
    end
  end

  describe "new feedback page" do
    it_behaves_like "all protected pages" do
      let(:protected_page) { new_user_feedback_path(other_user) }
    end
  end

  #scenario "clicking the 'Contact' link" do
  #  before { click_link("Contact") }
  #  page.should_behave_like "all protected pages"
  #end

  describe "signed-in users" do
    before { sign_in user }

    describe "visiting signup page" do
      before { visit new_user_path(type: 'host') }

      it { should_not have_title '|' }
      it { should have_selector 'h1', text: t('static_pages.home.welcome') }
    end

    describe "trying to edit another user" do
      let(:other_user) { create(:user) }
      before { visit edit_user_path(other_user) }
      it { should_not have_title full_title(t 'users.edit.title') }
    end

    describe "trying to leave feedback for themselves" do
      before { visit new_user_feedback_path(user) }
      it { should_not have_title t('users.show.leave_feedback') }
    end

  end # signed-in users

end # authorization
