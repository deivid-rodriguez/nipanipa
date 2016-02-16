# frozen_string_literal: true

#
# Unit tests for Message model
#
RSpec.describe Message do
  let!(:message) { build(:message) }

  it 'has a body' do
    expect(message).to validate_presence_of(:body)
  end

  it 'has a body between 2 and 500 characters' do
    expect(message).to validate_length_of(:body).is_at_least(2).is_at_most(500)
  end

  it 'belongs to a sender' do
    expect(message).to belong_to(:sender).class_name('User')
  end

  it 'belongs to a recipient' do
    expect(message).to belong_to(:recipient).class_name('User')
  end

  shared_context 'scopes' do
    let!(:volunteer) { create(:volunteer) }
    let!(:host) { create(:host) }
    let!(:msg) { create(:message, sender: host, recipient: volunteer) }
  end

  describe '.between' do
    include_context 'scopes'

    it 'returns only messages between the specified users' do
      create(:message, sender: volunteer)

      expect(Message.between(host.id, volunteer.id)).to eq([msg])
    end
  end

  describe '.non_deleted_by' do
    include_context 'scopes'

    it 'returns only conversations non deleted by the user' do
      create(:message, :deleted_by_sender, sender: volunteer, recipient: host)

      expect(Message.non_deleted_by(volunteer.id)).to eq([msg])
    end
  end

  describe '.involving' do
    include_context 'scopes'

    it 'returns only ids of messages involving a specific user' do
      create(:message, sender: host)

      expect(Message.involving(volunteer)).to eq([msg])
    end

    it 'returns only non deleted messages' do
      create(:message, :deleted_by_sender, sender: volunteer)

      expect(Message.involving(volunteer)).to eq([msg])
    end

    it 'returns only the last message in a conversation' do
      reply = create(:message, sender: volunteer, recipient: host)

      expect(Message.involving(volunteer)).to eq([reply])
    end

    it 'sorts messages latest first' do
      older_msg = create(:message, sender: volunteer, created_at: 3.hours.ago)

      expect(Message.involving(volunteer)).to eq([msg, older_msg])
    end
  end

  describe '.delete_by' do
    include_context 'scopes'

    it 'marks the message as deleted if a single user has deleted it' do
      Message.delete_by(volunteer.id)

      expect(Message.count).to eq(1)
      expect(Message.first.deleted_by_recipient_at).to_not be_nil
    end

    it 'actually deletes the message if deleted by both users' do
      Message.delete_by(volunteer.id)
      Message.delete_by(host.id)

      expect(Message.count).to eq(0)
    end
  end

  describe '#notify_recipient' do
    before { message.notify_recipient }

    it 'sends notification to recipient' do
      s = t('user_mailer.message_reception.subject', from: message.sender.name)
      expect(last_email.subject).to eq(s)

      expect(last_email.to).to eq([message.recipient.email])
      expect(last_email.from).to eq(['notifications@nipanipa.com'])

      expect(last_email.body.encoded).to \
        match(%r{/conversations/#{message.sender.id}})
    end
  end

  describe '#penpal' do
    let!(:msg) { create(:message) }

    it 'returns the sender if the recipient passed as a parameter' do
      expect(msg.penpal(msg.recipient)).to eq(msg.sender)
    end

    it 'returns the recipient if the sender passed as a parameter' do
      expect(msg.penpal(msg.sender)).to eq(msg.recipient)
    end
  end
end
