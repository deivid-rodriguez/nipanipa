require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') }
      it { should have_error_message('Invalid') }
      describe "after visiting another page" do
        before { click_link "NiPaNiPa" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end # with invalid information

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector('title', text: user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }

        it { should have_link('Sign in') }
        it { should_not have_link('Profile') }
        it { should_not have_link('Sign out') }
      end

    end # with valid information

  end # signin

  describe "authorization" do

    describe "for admin users" do
      let(:admin) { FactoryGirl.create(:admin) }
      before { sign_in admin }

      describe "submitting a DELETE request to itself" do
        before { delete user_path(admin) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "for non-admin" do
      let(:user) { FactoryGirl.create(:user) }

      describe "submitting a DELETE request to the Users#destroy action" do
        let(:non_admin) { FactoryGirl.create(:user) }
        before do
          sign_in non_admin
          delete user_path(user)
        end

        specify { response.should redirect_to(root_path) }
      end

      describe "non-signed-in users" do

        describe "when attempting to visit a protected page" do
          before do
            visit edit_user_path(user)
            sign_in user
          end

          describe "after signing in" do
            it "should render the desired protected page" do
              page.should have_selector('title', text: 'Edit user')
            end

            describe "when signing in again" do
              before do
                click_link "Sign out"
                sign_in user
              end
              it "should render the default (profile) page" do
                page.should have_selector('title', text: user.name)
              end
            end

          end # after signing in

        end # when attempting to visit a protected page

        describe "in the users controller" do
          describe "visiting the edit page" do
            before { visit edit_user_path(user) }
            it { should have_selector('title', text: 'Sign in') }
          end

          describe "submitting to the update action" do
            before { put user_path(user) }
            specify { response.should redirect_to(signin_path) }
          end

          describe "visiting the user index" do
            before { visit users_path }
            it { should have_selector('title', text: 'Sign in') }
          end
        end # in the users controller

        describe "in the feedbacks controller" do
          before { visit user_path(user) }

          describe "visiting the new feedback page" do
            before { visit new_user_feedback_path(user) }
            it { should have_selector('title', text: 'Sign in') }
          end

          describe "clicking the 'Leave feedback' link" do
            before { click_link("Leave feedback") }
            it { should have_selector('title', text: 'Sign in') }
          end

         #describe "clicking the 'Contact' link" do
         #  before { click_link("Contact") }
         #  it { should have_selector('title', 'Sign in') }
         #end

          describe "submitting to the create action" do
            before { post user_feedbacks_path(user) }
            specify { response.should redirect_to(signin_path) }
          end

         describe "submitting to the destroy action" do
           before { delete user_feedback_path(user,
                                              FactoryGirl.create(:feedback)) }
           specify { response.should redirect_to(signin_path) }
         end
        end

      end # non-signed-in users

      describe "signed-in users" do
        before { sign_in user }

        describe "visiting signup page" do
          before { visit signup_path }

          it { should_not have_selector('title', text: '|') }
          it { should have_selector('h1', text: 'Welcome to NiPaNiPa') }
        end

        describe "trying to edit another user" do
          let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
          before { sign_in user }

          describe "by visiting Users#edit page" do
            before { visit edit_user_path(wrong_user) }
            it { should_not have_selector('title', text: full_title('Edit user')) }
          end

          describe "by submitting a PUT request to the Users#update action" do
            before { put user_path(wrong_user) }
            specify { response.should redirect_to(root_path) }
          end
        end # trying to edit another user

        describe "trying to leave feedback for themselves" do
          describe "by visiting new feedback path" do
            before { visit new_user_feedback_path(user) }
            it { should_not have_selector('title', text: 'Leave feedback') }
          end
          describe "by submitting to the create action" do
            before { post user_feedbacks_path(user) }
            specify { response.should redirect_to(root_path) }
          end
        end # trying to leave feedback for themselves

      end # signed-in users

    end # for non-admin users

  end # authorization

end # Authentication
