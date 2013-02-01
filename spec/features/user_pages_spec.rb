require 'spec_helper'

feature "Signup Page" do

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

  background do
    visit signup_path('host')
  end

  scenario "signup page is correct" do
    page.should have_selector 'h1', text: t('users.new.header')
    page.should have_title full_title(t 'users.new.title')
  end

end

feature "Profile page" do

  given!(:user)      { create(:user) }
  given!(:feedback)  { create(:feedback, recipient: user) }

  background do
    visit user_path(user)
  end

  scenario "includes proper elements: header, title, user description, user
            location, user work description, user feedbacks and correct links
            depending on signin status" do
    page.should have_selector('h1', text: user.name)
    page.should have_title user.name
    page.should have_content user.description
    page.should have_content user.location.address
    page.should have_content user.work_description
    page.should have_content feedback.content
    page.should have_content user.received_feedbacks.count
    sign_in user
    page.should_not have_link t('users.show.leave_feedback')
    page.should_not have_link t('users.show.contact_user')
  end

end # profile page

feature "Profile edit page" do
  given(:user) { create(:user) }

  scenario "has correct header, title, and links" do
    sign_in user
    visit edit_user_path(user)
    page.should have_selector('h1', text: "Update your profile")
    page.should have_title 'Edit user'
    page.should have_link('change', href: "http://gravatar.com/emails")
  end

end # Profile edit page

feature "Signing up" do
  given(:user) { build_stubbed(:user) }
  given(:submit) { t 'users.new.submit' }

  background do
    visit signup_path('host')
  end

  scenario "submitting invalid information doesn't create user, redirects back
            to signup page and displays error messages" do
    expect { click_button submit }.not_to change(User, :count)
    page.should have_title t('users.new.title')
    page.should have_content('error')
  end

  scenario "submitting valid information creates user, signs in that user,
            redirect to his profile and flash a welcome message" do
    fill_signin_info user.name, user.email, user.password
    fill_in 'user[description]'     , with: user.description
    fill_in 'location'              , with: user.location.address
    fill_in 'user[work_description]', with: user.work_description
    #check 'work_type_9'

    expect { click_button submit }.to change(User, :count).by(1)
    page.should have_link t('sessions.signout')
    page.should have_title user.name
    page.should have_success_message 'Welcome'
  end

end # signup

feature "Profile editing" do
  given(:user) { create(:user) }
  given(:submit) { "Save changes" }
  given(:new_name) { "New name" }
  given(:new_email) { "new@example.com" }

  background do
    sign_in user
    visit edit_user_path(user)
  end

  scenario "with invalid information" do
    click_button submit
    page.should have_content 'error'
  end

  scenario "with valid information" do
    fill_signin_info new_name, new_email, user.password
    fill_in 'user[description]', with: user.description
    #check 'work_type_15'
    #check 'work_type_3'
    click_button submit

    page.should have_title new_name
    page.should have_selector 'div.alert.alert-success'
    page.should have_link t('sessions.signout'), href: signout_path
    user.reload.name.should  == new_name
    user.reload.email.should == new_email
    #user.reload.work_type_ids.should == [3, 15]
  end

end # edit

feature "Profile removing" do

end
