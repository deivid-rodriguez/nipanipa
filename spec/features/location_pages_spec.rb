require 'spec_helper'

# Run the generator again with the --webrat flag if you want to use webrat methods/matchers
describe "LocationPages" do

  subject { page }

  describe "location gets correctly saved" do

    let(:user) { create(:user) }
    before {
      visit new_user_path
      fill_signin_info(user.name, user.email, user.password)
      fill_in "location", with: "Madrid"
      click_button t("users.new.submit")
      visit user_path(user)
    }

    it { should have_content(user.location.address) }
    it { should have_selector("img[alt='map']") }

  end

end
