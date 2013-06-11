#
# Unit tests for Feedback model
#

describe Feedback do
  let(:feedback)  { build(:feedback) }

  subject { feedback }

  it { should respond_to(:content) }
  it { should respond_to(:sender_id) }
  it { should respond_to(:recipient_id) }
  it { should respond_to(:score) }
  its(:sender)    { should == feedback.sender }
  its(:recipient) { should == feedback.recipient }
  it { should respond_to(:complement) }

  it { should be_valid }

  describe 'presence validation' do
    context 'when sender is not present' do
      before { feedback.sender = nil }
      it { should_not be_valid }
    end

    context 'when recipient is not present' do
      before { feedback.recipient = nil }
      it { should_not be_valid }
    end
  end

  describe 'accessible attributes' do
    it "should not allow access to sender_id" do
      expect do
        Feedback.new(sender: build(:user))
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to recipient_id" do
      expect do
        Feedback.new(recipient: build(:user))
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  context 'with blank content' do
    before { feedback.content = ' ' }
    it { should_not be_valid }
  end

  context 'with content that is too long' do
    before { feedback.content = 'a' * 301 }
    it { should_not be_valid }
  end

  describe 'duplicated feedbacks' do
    let!(:other_feedback) do
      create(:feedback, sender: feedback.sender, recipient: feedback.recipient)
    end
    it { should_not be_valid }
  end

  describe '#complement' do
    let!(:other_feedback) do
      create(:feedback, sender: feedback.recipient, recipient: feedback.sender)
    end
    before { feedback.save }
    it { should == other_feedback.complement }
  end

  describe '#update_karma' do
    context 'when new_feedback' do
      it "initializes recipient's karma" do
        expect { feedback.save }.
          to change(feedback.recipient, :karma).by(feedback.score)
      end
    end

    context 'when updated feedback' do
      let!(:other_feedback) { create(:feedback, score: -1) }

      before { other_feedback.score = 1 }

      it "updates recipient's karma" do
        expect { other_feedback.save }.
          to change(other_feedback.recipient, :karma).by(2)
      end
    end
  end
end
