# == Schema Information
#
# Table name: feedbacks
#
#  id           :integer          not null, primary key
#  content      :string(255)
#  sender_id    :integer
#  recipient_id :integer
#  score        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Feedback do
  let(:sender)    { build_stubbed(:user) }
  let(:recipient) { build_stubbed(:user) }
  let(:feedback)  { build_stubbed(:feedback, sender: sender,
                                  recipient: recipient) }

  subject { feedback }

  it { should respond_to(:content) }
  it { should respond_to(:sender_id) }
  it { should respond_to(:recipient_id) }
  it { should respond_to(:score) }
  its(:sender)    { should == sender }
  its(:recipient) { should == recipient }
  it { should be_valid }

  describe "presence validation" do
    describe "when sender is not present" do
      before { feedback.sender = nil }
      it { should_not be_valid }
    end

    describe "when recipient is not present" do
      before { feedback.recipient = nil }
      it { should_not be_valid }
    end
  end

  describe "accessible attributes" do
    it "should not allow access to sender_id" do
      expect do
        Feedback.new(sender: sender.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to recipient_id" do
      expect do
        Feedback.new(recipient: recipient.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "with blank content" do
    before { feedback.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { feedback.content = "a" * 141 }
    it { should_not be_valid }
  end

  describe "duplicated feedbacks" do
    let!(:other_feedback) {
      create(:feedback, sender: sender, recipient: recipient) }
    it { should_not be_valid }
  end

end
