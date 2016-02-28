# frozen_string_literal: true

#
# Unit tests for Feedback model
#
RSpec.describe Feedback do
  let(:feedback) { build(:feedback) }

  subject { feedback }

  it { is_expected.to respond_to(:content) }
  it { is_expected.to respond_to(:sender_id) }
  it { is_expected.to respond_to(:recipient_id) }
  it { is_expected.to respond_to(:score) }

  describe '#sender' do
    subject { super().sender }

    it { is_expected.to eq(feedback.sender) }
  end

  describe '#recipient' do
    subject { super().recipient }

    it { is_expected.to eq(feedback.recipient) }
  end

  it { is_expected.to respond_to(:complement) }

  it { is_expected.to be_valid }

  describe "presence validation" do
    context "when sender is not present" do
      before { feedback.sender = nil }

      it { is_expected.not_to be_valid }
    end

    context "when recipient is not present" do
      before { feedback.recipient = nil }

      it { is_expected.not_to be_valid }
    end
  end

  context "with blank content" do
    before { feedback.content = " " }

    it { is_expected.not_to be_valid }
  end

  context "with content that is too long" do
    before { feedback.content = "a" * 301 }

    it { is_expected.not_to be_valid }
  end

  describe "duplicated feedbacks" do
    let!(:other_feedback) do
      create(:feedback, sender: feedback.sender, recipient: feedback.recipient)
    end

    it { is_expected.not_to be_valid }
  end

  describe '#complement' do
    let!(:other_feedback) do
      create(:feedback, sender: feedback.recipient, recipient: feedback.sender)
    end

    before { feedback.save }

    it { is_expected.to eq(other_feedback.complement) }
  end

  describe '#update_karma' do
    context "when new_feedback" do
      it "initializes recipient's karma" do
        expect { feedback.save }.to \
          change(feedback.recipient, :karma).by(feedback.score.value)
      end
    end

    context "when updated feedback" do
      let!(:other_feedback) { create(:feedback, score: :negative) }

      before { other_feedback.score = :positive }

      it "updates recipient's karma" do
        expect { other_feedback.save }.to \
          change(other_feedback.recipient, :karma).by(2)
      end
    end

    context "when destroyed feedback" do
      let!(:other_feedback) { create(:feedback, score: :negative) }

      it "updates recipient's karma" do
        expect { other_feedback.destroy }.to \
          change(other_feedback.recipient, :karma).by(1)
      end
    end
  end
end
