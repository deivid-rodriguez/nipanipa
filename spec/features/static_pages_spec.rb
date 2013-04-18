describe "Static pages" do

  let(:help)    { t 'static_pages.help.title' }
  let(:about)   { t 'static_pages.about.title' }
  let(:contact) { t 'static_pages.contact.title' }

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_title full_title(page_title) }
    it { should have_link help                    }
    it { should have_link about                   }
    it { should have_link contact                 }
    it { should have_link "NiPaNiPa"              }
  end

  describe "Home Page" do
    let(:page_title) { '' }
    before { visit root_path }

    it_should_behave_like "all static pages"
    it { should_not have_title '| Home' }
  end


  describe "Help Page" do
    let(:page_title) { help }
    before { visit help_path }

    it { should have_selector 'h1', text: help }
    it_should_behave_like "all static pages"
  end

  describe "About Page" do
    let(:page_title) { about }
    before { visit about_path }

    it { should have_selector 'h1', text: about }
    it_should_behave_like "all static pages"
  end

  describe "Contact Page" do
    before { visit contact_path }
    let(:page_title) { contact }

    it { should have_selector 'h1', text: contact }
    it_should_behave_like "all static pages"
  end

  describe "robots.txt file" do
    before { visit '/robots.txt' }
    it { should have_content File.read('config/robots.test.txt') }
  end
end
