def mock_paypal_pdt(status, donation_id)
  WebMock::API.
    stub_request(:post, "https://www.sandbox.paypal.com/cgi-bin/webscr?").
      with(
        body: {
          at:  "ihDkGClTsjbX-7eAsFrzOHwyNlSgcArJDCEWI5dl8fMLE1I5dBrIrCzGdqm",
          cmd: "_notify-synch",
          tx:  "4YD48288L7608774D"},
        headers: {
          'Accept'       => '*/*',
          'Content-Type' => 'application/x-www-form-urlencoded',
          'User-Agent'   => 'Ruby'}).
      to_return(status: 200, body: "#{status}", headers: {})
  visit "/es/donations/#{donation_id}?tx=4YD48288L7608774D&st=Completed&amt=2" \
        "0.00&cc=USD&cm=&item_number=&sig=jpnQ%2fNXbC0KdUzVDVMxw%2fGr1RxxvWDI" \
        "qwlNT9W6f0lxGH66BxUIhzRj8vJW8jwh0DVqyE4ZUaxHTmQVry2yxR5bR8ge3kA1tVgo" \
        "9Qc5%2bU2ErQVmvOJ555ABbqk4pMbBG7qaHNkqxD33JZk%2f3Hl9bnBj46gztBvlnYux" \
        "d5jGRP8Q%3d"
end

feature 'donation', js: true do
  background do
    visit new_donation_path
    select '20', from: 'donation[amount]'
    click_button t('donations.new.submit')
    expect { Donation.count }.to change_by(1)
  end

  scenario "successful donation" do
    mock_paypal_pdt('SUCCESS', Donation.last.id)
    page.should have_flash_message t('donations.create.success'), 'success'
  end

  scenario "unsuccessful donation" do
    mock_paypal_pdt('FAIL', Donation.last.id)
    page.should have_flash_message t('donations.create.error'), 'error'
  end
end
