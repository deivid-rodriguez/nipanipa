#
# Unit tests for Conversation model
#

describe Conversation do
  it 'has a valid factory' do
    create(:conversation).should be_valid
  end

  it 'has a valid soft factory' do
    build(:conversation).should be_valid
  end

  it { should validate_presence_of(:subject) }
  it { should ensure_length_of(:subject).is_at_least(2) }
  it { should ensure_length_of(:subject).is_at_most(72) }

  it { should have_many(:messages).dependent(:destroy) }

  it { should accept_nested_attributes_for(:messages) }

  it { should belong_to(:from).class_name('User') }
  it { should belong_to(:to).class_name('User') }

  describe 'methods' do
    let!(:conversation) { build(:conversation) }

    it '#mark_as_deleted' do
      conversation.mark_as_deleted(conversation.from)
      conversation.deleted_from.should be_true

      conversation.mark_as_deleted(conversation.to)
      conversation.deleted_to.should be_true
    end

    it '#deleted_by_both' do
      conversation.deleted_by_both?.should be_false
      conversation.mark_as_deleted(conversation.from)
      conversation.mark_as_deleted(conversation.to)
      conversation.deleted_by_both?.should be_true
    end
  end

end
