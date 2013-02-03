require 'spec_helper'

describe "Static pages" do

  let(:help)    { t 'static_pages.help.title' }
  let(:about)   { t 'static_pages.about.title' }
  let(:contact) { t 'static_pages.contact.title' }

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector 'h1', text: heading }
    it { should have_title full_title(page_title) }
    it { should have_link help                    }
    it { should have_link about                   }
    it { should have_link contact                 }
    it { should have_link "NiPaNiPa"              }
  end

  describe "Home Page" do
    before { visit root_path }
    let(:heading) { 'NiPaNiPa' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title '| Home' }
    it { should have_link t('.static_pages.home.host') }
    it { should have_link t('.static_pages.home.volunteer') }
  end

  describe "Help Page" do
    before { visit help_path }
    let(:heading) { help }
    let(:page_title) { help }

    it_should_behave_like "all static pages"
  end

  describe "About Page" do
    before { visit about_path }
    let(:heading) { about }
    let(:page_title) { about }

    it_should_behave_like "all static pages"
  end

  describe "Contact Page" do
    before { visit contact_path }
    let(:heading) { contact }
    let(:page_title) { contact }

    it_should_behave_like "all static pages"
  end
end
