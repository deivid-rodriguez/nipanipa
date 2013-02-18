#feature 'donation', driver: :selenium do
#
#  background do
#    visit new_donation_path
#    select '20', from: 'donation[amount]'
#    click_button t 'donations.new.submit'
#  end
#
#  # Think how to test these...
#  scenario 'successful' do
##   page.should have_success_message t('donations.new.flash_success')
#  end
#
#  scenario 'unsuccessful' do
##   page.should have_success_message t('donations.new.flash_alert')
#  end
#
#end
