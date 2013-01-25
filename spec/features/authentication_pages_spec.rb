require 'spec_helper'

describe "Authentication" do
  let(:signin)  { t 'sessions.signin'  }
  let(:signout) { t 'sessions.signout' }

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector 'h1', text: signin }
    it { should have_title signin }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button signin }

      it { should have_title signin }
      it { should have_error_message('Invalid') }
      describe "after visiting another page" do
        before { click_link "NiPaNiPa" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end # with invalid information

    describe "with valid information" do
      let(:profile) { t 'users.show.profile' }
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_title user.name }
      it { should have_link profile, href: user_path(user) }
      it { should have_link signout, href: signout_path }
      it { should_not have_link signin, href: signin_path }

      describe "followed by signout" do
        before { click_link signout }

        it { should have_link signin }
        it { should_not have_link t('users.show.profile') }
        it { should_not have_link signout }
      end

    end # with valid information

  end # signin

  describe "authorization" do

    describe "for non-admin" do
      let(:user) { FactoryGirl.create(:user) }

      describe "non-signed-in users" do

        describe "when attempting to visit a protected page" do
          before do
            visit edit_user_path(user)
            sign_in user
          end

          describe "after signing in" do
            it "should render the desired protected page" do
              page.should have_title 'Edit user'
            end

            describe "when signing in again" do
              before do
                click_link signout
                sign_in user
              end
              it "should render the default (profile) page" do
                page.should have_title user.name
              end
            end

          end # after signing in

        end # when attempting to visit a protected page

        describe "in the users controller" do
          describe "visiting the edit page" do
            before { visit edit_user_path(user) }
            it { should have_title signin }
          end

          describe "visiting the user index" do
            before { visit users_path }
            it { should have_title signin }
          end
        end # in the users controller

        describe "in the feedbacks controller" do
          before { visit user_path(user) }

          describe "visiting the new feedback page" do
            before { visit new_user_feedback_path(user) }
            it { should have_title signin }
          end

          describe "clicking leave feedback's link" do
            before { click_link t('users.show.leave_feedback') }
            it { should have_title signin }
          end

         #describe "clicking the 'Contact' link" do
         #  before { click_link("Contact") }
         #  it { should have_title signin }
         #end

        end

      end # non-signed-in users

      describe "signed-in users" do
        before { sign_in user }

        describe "visiting signup page" do
          before { visit signup_path }

          it { should_not have_title '|' }
          it { should have_selector 'h1', text: t('static_pages.home.welcome') }
        end

        describe "trying to edit another user" do
          let(:other_user) { FactoryGirl.create(:user) }
          before { visit edit_user_path(other_user) }
          it { should_not have_title full_title('Edit user') }
        end

        describe "trying to leave feedback for themselves" do
          before { visit new_user_feedback_path(user) }
          it { should_not have_title t('users.show.leave_feedback') }
        end

      end # signed-in users

    end # for non-admin users

  end # authorization

end # Authentication
