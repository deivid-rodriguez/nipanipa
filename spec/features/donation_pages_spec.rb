describe 'donation' do
  before do
    Capybara.current_driver = :mechanize
    visit new_donation_path
    select '20', from: 'donation[amount]'
    click_button t('helpers.submit.donation.create')
    expect { Donation.count }.to become(1)
  end

  after { Capybara.use_default_driver }

  subject { page }

  context 'when successful donation' do
    before { mock_paypal_pdt('SUCCESS', Donation.last.id) }
    it { should have_flash_message t('donations.create.success'), 'success' }
  end

  context 'when unsuccessful donation' do
    before { mock_paypal_pdt('FAIL', Donation.last.id) }
    it { should have_flash_message t('donations.create.error'), 'error' }
  end
end
