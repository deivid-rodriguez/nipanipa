#
# Integration tests for the "Offer" resource
#

def fill_in_minimum_info
  fill_in 'offer[title]'       , with: offer.title
  fill_in 'offer[description]' , with: offer.description
  fill_in 'offer[accomodation]', with: offer.accomodation
  select "#{offer.vacancies}"  , from: 'offer[vacancies]'
end

feature "Offer creation" do
  given(:user)       { create(:host) }
  given(:btn_name)   { t('helpers.submit.create', model: Offer) }
  given!(:work_type) { create(:work_type, name: 'cooking') }
  given(:offer)      { build(:offer) }

  background do
    sign_in user
    click_link t('offers.new.link')
  end

  scenario "with invalid information" do
    click_button btn_name
    page.should have_flash_message t('offers.create.error'), 'error'
  end

  scenario "with minimal information" do
    fill_in_minimum_info
    click_button btn_name
    page.should have_flash_message t('offers.create.success'), 'success'
  end

  scenario "with full information" do
    fill_in_minimum_info
    select "#{offer.hours_per_day}", from: 'offer[hours_per_day]'
    select "#{offer.days_per_week}", from: 'offer[hours_per_day]'
    select "#{offer.min_stay}"     , from: 'offer[hours_per_day]'
    check 'cooking'
    click_button btn_name
    page.should have_flash_message t('offers.create.success'), 'success'
  end

end

feature "Offer removal" do
end

feature "Offer display" do
end

feature "Offer listing" do
  given(:host) { create(:active_host, count: 2) }

  scenario "offers are listed in host's profile" do
    visit user_path host
    page.should have_content host.offers.first.title
    page.should have_content host.offers.last.title
  end
end

feature "Offer edition" do
end
