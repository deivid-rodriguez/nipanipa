require 'spec_helper'

describe "User Pages" do

  subject { page }

  # Save pagination test for searches
  #
  #  describe "pagination" do
  #    before(:all) { 30.times { build(:user) } }
  #
  #    it { should have_selector('div.pagination') }
  #
  #    it "should list each user" do
  #      User.paginate(page: 1).each do |user|
  #        page.should have_selector('li', text: user.name)
  #      end
  #    end
  #
  #  end # pagination

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector 'h1', text: t('users.new.header') }
    it { should have_title full_title(t 'users.new.title') }
  end

  describe "profile page" do
    let(:user) { create(:user) }
    let!(:r1) { create(:feedback, recipient: user) }
    let!(:r2) { create(:feedback, recipient: user) }

    before { visit user_path(user) }

    it { should have_selector('h1', text: user.name) }
    it { should have_title user.name }

    describe "description" do
      it { should have_content(user.description) }
    end

    describe "location" do
      it { should have_content(user.location.address) }
    end

    describe "work description" do
      it { should have_content(user.work_description) }
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
      it { should_not have_link t('users.show.leave_feedback') }
      it { should_not have_link t('users.show.contact_user') }
    end

  end # profile page

  describe "signup" do
    let(:user) { build(:user) }

    before { visit signup_path }

    let(:submit) { t 'users.new.submit' }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title t('users.new.title') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before {
        fill_signin_info user.name, user.email, user.password
        fill_in 'user[description]'     , with: user.description
        fill_in 'location'              , with: user.location.address
        fill_in 'user[work_description]', with: user.work_description
#       check 'work_type_9'
      }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }

        it { should have_title user.name }
        it { should have_success_message('Welcome') }
        it { should have_link(t('sessions.signout')) }
      end

    end # with valid information

  end # signup


  describe "edit" do
    let(:user) { create(:user) }
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
#       fill_in "Personal description", with: user.description
#       check 'work_type_15'
#       check 'work_type_3'
        click_button submit
      end

      it { should have_title new_name }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link t('sessions.signout'), href: signout_path }
      specify { user.reload.name.should  == new_name  }
      specify { user.reload.email.should == new_email }
#     specify { user.reload.work_type_ids.should == [3, 15] }
    end

  end # edit

end
