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
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  before do
    @feedback = Feedback.new
    @feedback.content   = "Debuti tio gracias. Ha sido una estancia genial."
    @feedback.score     = 1
    @feedback.sender    = user1
    @feedback.recipient = user2
  end

  subject { @feedback }

  it { should respond_to(:content) }
  it { should respond_to(:sender_id) }
  it { should respond_to(:recipient_id) }
  it { should respond_to(:score) }
  its(:sender) { should == user1 }
  its(:recipient) { should == user2 }
  it { should be_valid }

  describe "presence validation" do
    describe "when sender is not present" do
      before { @feedback.sender = nil }
      it { should_not be_valid }
    end

    describe "when recipient is not present" do
      before { @feedback.recipient = nil }
      it { should_not be_valid }
    end
  end

  describe "accessible attributes" do
    it "should not allow access to sender_id" do
      expect do
        Feedback.new(sender: user1.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to recipient_id" do
      expect do
        Feedback.new(recipient: user2.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "with blank content" do
    before { @feedback.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @feedback.content = "a" * 141 }
    it { should_not be_valid }
  end

  describe "duplicated feedbacks" do
    before do
      @other_feedback = Feedback.new
      @other_feedback.content = "Another feedback for that same user"
      @other_feedback.sender = user1
      @other_feedback.recipient = user2
      @other_feedback.score = 1
      @other_feedback.save!
    end
    it { should_not be_valid }
  end

end
