#
# Integration tests for Donation pages
#
RSpec.describe 'donation' do
  describe 'shows a flattr button', :js do
    before do
      visit root_path
      click_link t('layouts.header.donate')
    end

    it 'shows flattr button' do
      expect(page).to have_selector(:xpath, "//iframe[@title='Flattr']")
    end
  end

  describe 'leaving a donation', :with_fake_paypal do
    before do
      visit new_donation_path
      select '20', from: 'donation[amount]'
      click_button t('helpers.submit.donation.create')
    end

    it 'saves the donation in database' do
      expect { Donation.count }.to become(1)
    end

    it 'shows a success flash message' do
      expect(page).to \
        have_flash_message t('donations.create.success'), 'success'
    end
  end
end
