#
# Integration tests for Static pages
#
RSpec.describe 'Static pages' do
  let(:help) { t 'static_pages.help.title' }
  let(:about) { t 'static_pages.about.title' }
  let(:contact) { t 'static_pages.contact.title' }

  subject { page }

  shared_examples_for 'all static pages' do
    it { is_expected.to have_title full_title(page_title) }
    it { is_expected.to have_link help }
    it { is_expected.to have_link about }
    it { is_expected.to have_link contact }
    it { is_expected.to have_link 'NiPaNiPa' }
  end

  describe 'Home Page' do
    let(:page_title) { '' }

    before { visit root_path }

    it_behaves_like 'all static pages'

    it { is_expected.not_to have_title '| Home' }
    it { is_expected.not_to have_link t('static_pages.home.signup') }
  end

  describe 'Help Page' do
    let(:page_title) { help }

    before { visit help_path }

    it_behaves_like 'all static pages'

    it { is_expected.to have_selector 'h2', text: help }
  end

  describe 'About Page' do
    let(:page_title) { about }

    before { visit about_path }

    it_behaves_like 'all static pages'

    it { is_expected.to have_selector 'h2', text: about }
  end

  describe 'Contact Page' do
    let(:page_title) { contact }

    before { visit contact_path }

    it_behaves_like 'all static pages'

    it { is_expected.to have_selector 'h2', text: contact }
  end

  describe 'robots.txt file' do
    before { visit '/robots.txt' }

    it { is_expected.to have_content File.read('config/robots.test.txt') }
  end
end
