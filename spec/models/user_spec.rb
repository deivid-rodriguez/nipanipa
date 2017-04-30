# frozen_string_literal: true

#
# Unit tests for User model
#
RSpec.describe User do
  let(:user) { build(:user) }

  subject { user }

  it { is_expected.to respond_to(:availability) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:encrypted_password) }
  it { is_expected.to respond_to(:languages) }
  it { is_expected.to respond_to(:last_sign_in_ip) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:remember_created_at) }
  it { is_expected.to respond_to(:type) }

  describe "when name is not present" do
    before { user.name = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when name is too long" do
    before { user.name = "a" * 51 }
    it { is_expected.not_to be_valid }
  end

  describe "when email is not present" do
    before { user.email = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    let!(:user_with_same_email) { user.dup }
    before do
      user_with_same_email = user.dup
      user_with_same_email.save
    end

    it { is_expected.not_to be_valid }
  end

  describe "when password is not present" do
    before { user.password = user.password_confirmation = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { user.password_confirmation = "mismatch" }
    it { is_expected.not_to be_valid }
  end

  describe "with a password that's too short" do
    before { user.password = user.password_confirmation = "a" * 5 }
    it { is_expected.to be_invalid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      user.email = mixed_case_email
      user.save
      expect(user.reload.email).to eq(mixed_case_email.downcase)
    end
  end

  describe "feedbacks associations" do
    before { user.save }
    let!(:sent_f) { create(:feedback, sender: user) }
    let!(:old_f) { create(:feedback, recipient: user, created_at: 1.day.ago) }
    let!(:new_f) { create(:feedback, recipient: user, created_at: 1.hour.ago) }

    it "should have the right received feedbacks in the right order" do
      expect(user.received_feedbacks).to eq([new_f, old_f])
    end

    it "should destroy associated sent feedbacks" do
      sent_feedbacks = user.sent_feedbacks.to_a
      user.destroy
      expect(sent_feedbacks).not_to be_empty
      sent_feedbacks.each do |sent_feedback|
        expect(Feedback.find_by(id: sent_feedback.id)).to be_nil
      end
    end

    it "should destroy associated received feedbacks" do
      received_feedbacks = user.received_feedbacks.to_a
      user.destroy
      expect(received_feedbacks).not_to be_empty
      received_feedbacks.each do |received_feedback|
        expect(Feedback.find_by(id: received_feedback.id)).to be_nil
      end
    end
  end

  describe "when description too long" do
    before { user.description = "a" * 2501 }
    it { is_expected.not_to be_valid }
  end

  describe "scopes" do
    describe ".by_latest_sign_in" do
      let(:never_signed_in) { create(:user, last_sign_in_at: nil) }
      let(:just_signed_in) { create(:user, last_sign_in_at: 2.seconds.ago) }
      let(:signed_in_a_while_ago) { create(:user, last_sign_in_at: 1.year.ago) }

      it "sorts by sign in time" do
        expect(User.by_latest_sign_in).to \
          eq([just_signed_in, signed_in_a_while_ago, never_signed_in])
      end
    end

    describe ".from_continent" do
      let!(:user) { create(:user, continent: create(:continent)) }

      it "filters users by continent" do
        expect(User.from_continent(user.continent)).to include(user)
      end
    end

    describe ".from_country" do
      let!(:user) { create(:user, country: create(:country)) }

      it "filters users by country" do
        expect(User.from_country(user.country)).to include(user)
      end
    end
  end
end
