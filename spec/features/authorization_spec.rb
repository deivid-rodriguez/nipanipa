describe "User" do

  describe "abilities" do
    subject { ability }
    let(:volunteer) { nil }
    let(:ability) { Ability.new(volunteer) }

    context "when is a regular logged in user" do
      let!(:volunteer) { create(:volunteer) }
      let!(:feedback_by_me) { build(:feedback, sender: volunteer) }
      let!(:feedback_for_me) { build(:feedback, recipient: volunteer) }

      before do
       visit root_path
       sign_in volunteer
      end

      it { should be_able_to(:manage, feedback_by_me) }
      it { should_not be_able_to(:manage, feedback_for_me) }
    end
  end

end

describe "Protected pages" do
  let!(:user)       { create(:host) }
  let!(:other_user) { create(:volunteer) }

  subject { page }

  shared_examples "all protected pages" do
    describe "back and redirect" do
      it "stores redirects back after log in and then forgets" do
        visit protected_page
        page.should have_title t('sessions.signin')
        fill_in 'user[email]',    with: user.email
        fill_in 'user[password]', with: user.password
        click_button t('sessions.signin')
        current_path.should == protected_page
        click_link t('sessions.signout')
        sign_in user
        page.should have_title user.name
      end
    end
  end

  describe "edit profile page" do
    it_behaves_like "all protected pages" do
      let(:protected_page) { edit_user_registration_path }
    end
  end

  describe "new feedback page" do
    it_behaves_like "all protected pages" do
      let(:protected_page) { new_user_feedback_path(other_user) }
    end
  end

  #scenario "clicking the 'Contact' link" do
  #  before { click_link("Contact") }
  #  page.should_behave_like "all protected pages"
  #end

  describe "signed-in users" do
    before do
      visit root_path
      sign_in user
    end

    describe "visiting signup page" do
      before { visit new_user_registration_path(type: "host") }
      specify { current_path.should == user_path(user) }
    end
  end

end
