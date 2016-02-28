# frozen_string_literal: true

#
# Integration tests for Authentication pages
#
RSpec.describe "Signin" do
  let(:signin) { t("sessions.signin") }
  let(:signout) { t("sessions.signout") }
  let(:profile) { t("users.show.profile") }
  let(:user) { create(:host) }

  before { visit root_path }

  describe "page has correct content" do
    before { visit new_user_session_path }

    it "has correct title" do
      expect(page).to have_title signin
    end
  end

  describe "dropdown menu has correct content" do
    before { click_link signin }

    it "has user field" do
      expect(page).to have_selector 'input#user_email'
    end

    it "has password field" do
      expect(page).to have_selector 'input#user_password'
    end
  end

  context "with invalid information" do
    before do
      click_link signin
      click_button signin
    end

    it "goes back to signin page" do
      expect(page).to have_title signin
    end

    it "shows an error flash message" do
      expect(page).to have_flash_message(
        t("devise.failure.invalid", authentication_keys: "email"), "danger")
    end
  end

  context "with valid information" do
    before { sign_in user }

    it "goes to signed in user profile" do
      expect(page).to have_title user.name
    end

    it "has a link to users profile" do
      expect(page).to have_link profile, href: user_path(user)
    end

    it "does not have a link to signin" do
      expect(page).not_to have_link signin, href: new_user_session_path
    end

    context "and then signout" do
      before { click_link signout }

      it "has a link to signin" do
        expect(page).to have_link signin
      end

      it "has a link to users profile" do
        expect(page).not_to have_link profile, href: user_path(user)
      end

      it "does not have a link to sigout" do
        expect(page).not_to have_link signout
      end
    end
  end
end

RSpec.describe "Password recovery" do
  let!(:user) { create(:volunteer) }
  let!(:paranoid_msg) { t("devise.passwords.send_paranoid_instructions") }

  before do
    visit root_path
    click_link t("sessions.signin")
    click_link t("sessions.forgot_your_pwd?")
  end

  shared_examples_for "paranoid" do
    it "has a success flash message" do
      expect(page).to have_flash_message paranoid_msg, "success"
    end
  end

  context "with correct email" do
    before do
      within "div.form-thumbnail" do
        fill_in "user[email]", with: user.email
        click_button t("devise.passwords.new.send_instructions")
      end
    end

    it_behaves_like "paranoid"

    it "sends_notification email" do
      expect(sent_emails.size).to eq(1)
      expect(last_email.to).to include(user.email)
    end
  end

  context "with wrong email" do
    before do
      within "div.form-thumbnail" do
        fill_in "user[email]", with: "mywrongemail@example.com"
        click_button t("devise.passwords.new.send_instructions")
      end
    end

    it_behaves_like "paranoid"

    it "does not send notification email" do
      expect(sent_emails).to be_empty
    end
  end
end
