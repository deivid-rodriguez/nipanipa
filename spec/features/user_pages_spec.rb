require 'spec_helper'

describe "User Pages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title 'All users' }
    it { should have_selector('h1', text: 'All users') }

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end

    end # pagination

    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete').to change(User, :count).by(-1) }
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end

    end # delete links

  end # index

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1', text: 'Sign up') }
    it { should have_title full_title('Sign up') }
  end

  describe "profile page" do
    let(:user)      { FactoryGirl.create(:user) }
    let(:sender1)   { FactoryGirl.create(:user) }
    let(:sender2)   { FactoryGirl.create(:user) }
    let!(:r1) { FactoryGirl.create(:feedback,
                                   sender: sender1,
                                   recipient: user,
                                   content: "Amazing stay. Thanks!") }
    let!(:r2) { FactoryGirl.create(:feedback,
                                   sender: sender2,
                                   recipient: user,
                                   content: "Woooow!! That was fun!!!") }

    before { visit user_path(user) }

    it { should have_selector('h1', text: user.name) }
    it { should have_title user.name }

    describe "description" do
      it { should have_content(user.description) }
    end

    describe "feedbacks" do
      it { should have_content(r1.content) }
      it { should have_content(r2.content) }
      it { should have_content(user.received_feedbacks.count) }
    end

    describe "when user signed in and looking at its own profile" do
      before do
        sign_in user
        visit user_path(user)
      end
      it { should_not have_link('Leave feedback') }
      it { should_not have_link('Contact user') }
    end

  end # profile page

  describe "signup" do

    before { visit signup_path }

    let(:submit) { 'Create my account' }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title 'Sign up' }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before { fill_signin_info "exampleUser",
                                #"nipanipa.test+exampleUser@gmail.com",
                                "exampleUser@example.com",
                                "123456"
               fill_in "Personal description", with: 'Nice description of me'
               check 'work_type_9'
      }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('nipanipa.test+user1@gmail.com') }

        it { should have_title user.name }
        it { should have_success_message('Welcome') }
        it { should have_link('Sign out') }
      end

    end # with valid information

  end # signup

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    let(:submit) { "Save changes" }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1', text: "Update your profile") }
      it { should have_title 'Edit user' }
      it { should have_link('change', href: "http://gravatar.com/emails") }
    end

    describe "with invalid information" do
      before { click_button submit }
      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_signin_info new_name, new_email, user.password
        fill_in "Personal description", with: user.description
        check 'work_type_15'
        click_button submit
      end

      it { should have_title new_name }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name  }
      specify { user.reload.email.should == new_email }
    end

  end # edit

end
