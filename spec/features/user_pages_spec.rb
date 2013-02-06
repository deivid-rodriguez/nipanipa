require 'spec_helper'

feature "User profile creation" do
  given(:user)       { build(:user) } # build_stubbed??
  given!(:work_type) { create(:work_type) }
  given(:submit)     { t 'helpers.submit.user.create' }

  background { visit new_user_path(type: 'host') }

  scenario "signup page has proper content" do
    page.should have_selector 'h1', text: t('users.new.header', type: 'Host')
    page.should have_title full_title(t 'users.new.title')
    page.should_not have_link "NiPaNiPa"
    page.should have_selector 'label', text: work_type.name
  end

  scenario "submitting invalid information doesn't create user, redirects back
            to signup page and displays error messages" do
    expect { click_button submit }.not_to change(User, :count)
    page.should have_title t('users.new.title')
    page.should have_selector '.error'
  end

  scenario "submitting valid information creates user, signs in that user,
            redirect to his profile and flash a welcome message" do
    fill_in 'user[name]'                 , with: user.name
    fill_in 'user[email]'                , with: user.email
    fill_in 'user[password]'             , with: user.password
    fill_in 'user[password_confirmation]', with: user.password
    fill_in 'user[description]'          , with: user.description
    fill_in 'location'                   , with: user.location.address
    fill_in 'user[work_description]'     , with: user.work_description
    check "user_work_type_ids_#{work_type.id}"

    expect { click_button submit }.to change(User, :count).by(1)
    page.should have_title user.name
    page.should have_success_message t('users.new.flash_success')
    page.should have_link t('sessions.signout')
  end
end

feature "User profile display" do
  given(:feedback) { create(:feedback) }
  given(:user)     { feedback.recipient }

  background { visit user_path(user) }

  scenario "includes proper elements: header, title, user description, user
            location, user work description, user feedbacks and count" do
    page.should have_selector('h1', text: user.name)
    page.should have_title user.name
    page.should have_content(user.description)
    page.should have_content(user.location.address)
    page.should have_content(user.work_description)
    page.should have_content(feedback.content)
    page.should have_content(user.received_feedbacks.count)
  end

  scenario "when user not signed in / signed in & looking at external profile" do
    page.should have_link t('users.show.leave_feedback')
    page.should have_link t('users.show.contact_user')
  end

  scenario "when user signed in & looking at its own profile" do
    sign_in user
    page.should_not have_link t('users.show.leave_feedback')
    page.should_not have_link t('users.show.contact_user')
  end
end

feature "User profile editing" do
  given(:sectorization) { create(:sectorization)         }
  given(:user)          { sectorization.user             }
  given(:work_type)     { sectorization.work_type        }
  given(:submit)        { t 'helpers.submit.user.update' }
  given(:new_name)      { "New name"                     }

  background do
    visit edit_user_path(user)
    sign_in user
  end

  scenario "profile page has correct header, title and links" do
    page.should have_selector 'h1', text: t('users.edit.header')
    page.should have_title t('users.edit.title')
    page.should have_link 'change', href: "http://gravatar.com/emails"
  end

  scenario "with invalid information" do
    click_button submit
    page.should have_selector '.error'
  end

  scenario "with valid information" do
    fill_in 'user[name]',                  with: new_name
    fill_in 'user[password]'             , with: user.password
    fill_in 'user[password_confirmation]', with: user.password
    check "user_work_type_ids_#{work_type.id}"
    click_button submit

    page.should have_title new_name
    page.should have_success_message t('users.edit.flash_success')
    page.should have_link t('sessions.signout'), href: signout_path
    user.reload.name.should  == new_name
    user.reload.work_type_ids.should == [ work_type.id ]
  end
end

feature "User profile removing" do

end

feature "User profile index" do

  background do
    15.times { build(:user) }
    visit users_path
  end

  scenario "Explore all profiles from home page" do

    User.paginate(page: 1).each do |user|
      page.should have_selector('li', text: user.name)
    end
  end

end
