#
# Unit tests for Conversation model
#

RSpec.describe Conversation do
  it 'has a valid factory' do
    expect(create(:conversation)).to be_valid
  end

  it 'has a valid soft factory' do
    expect(build(:conversation)).to be_valid
  end

  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to ensure_length_of(:subject).is_at_least(2) }
  it { is_expected.to ensure_length_of(:subject).is_at_most(72) }

  it { is_expected.to have_many(:messages).dependent(:destroy) }

  it { is_expected.to accept_nested_attributes_for(:messages) }

  it { is_expected.to belong_to(:from).class_name('User') }
  it { is_expected.to belong_to(:to).class_name('User') }

  describe 'methods' do
    let!(:conversation) { build(:conversation) }

    it '#mark_as_deleted' do
      conversation.mark_as_deleted(conversation.from)
      expect(conversation.deleted_from).to be_truthy

      conversation.mark_as_deleted(conversation.to)
      expect(conversation.deleted_to).to be_truthy
    end

    it '#deleted_by_both' do
      expect(conversation.deleted_by_both?).to be_falsey
      conversation.mark_as_deleted(conversation.from)
      conversation.mark_as_deleted(conversation.to)
      expect(conversation.deleted_by_both?).to be_truthy
    end
  end
end
