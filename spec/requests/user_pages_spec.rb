require 'spec_helper'

describe "User Pages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
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

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

  describe "profile page" do
    let(:recipient) { FactoryGirl.create(:user) }
    let(:sender1)   { FactoryGirl.create(:user) }
    let(:sender2)   { FactoryGirl.create(:user) }
    let!(:r1) { FactoryGirl.create(:feedback,
                                   sender: sender1,
                                   recipient: recipient,
                                   content: "Amazing stay. Thanks!") }
    let!(:r2) { FactoryGirl.create(:feedback,
                                   sender: sender2,
                                   recipient: recipient,
                                   content: "Woooow!! That was fun!!!") }

    before { visit user_path(recipient) }

    it { should have_selector('h1',    text: recipient.name) }
    it { should have_selector('title', text: recipient.name) }

    describe "feedbacks" do
      it { should have_content(r1.content) }
      it { should have_content(r2.content) }
      it { should have_content(recipient.received_feedbacks.count) }
    end

    describe "when user signed in and looking at its own profile" do
      before do
        sign_in recipient
        visit user_path(recipient)
      end
      it { should_not have_link('Leave feedback') }
      it { should_not have_link('Contact user') }
    end

  end # profile page

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      before { fill_profile "user1", "nipanipa.test+user1", "123456" }

      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before { fill_profile "user1", "nipanipa.test+user1@gmail.com", "123456" }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('nipanipa.test+user1@gmail.com') }

        it { should have_selector('title', text: user.name) }
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
      it { should have_selector('title', text: "Edit user") }
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
        fill_profile new_name, new_email, user.password
        click_button submit
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name  }
      specify { user.reload.email.should == new_email }
    end

  end # edit

end
