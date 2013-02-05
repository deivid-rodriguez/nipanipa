require 'spec_helper'

feature 'donation', driver: :selenium do

  background do
    visit donate_path
    select '20', from: :amount
    click_button t '.static_pages.donate.submit'
  end

  scenario 'successful' do
#    page.should have_success_message 'Donation successful'
  end

  scenario 'unsuccessful' do
#    page.should have_success_message 'Donation unsuccessful'
  end

end
