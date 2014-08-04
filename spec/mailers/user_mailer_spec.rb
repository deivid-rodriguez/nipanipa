#
# Tests for UserMailer
#

RSpec.describe UserMailer do
  describe 'message_reception' do
    let!(:conv) { create(:conversation) }
    let(:mail) { UserMailer.message_reception(conv.messages.first) }

    it 'sends notification to recipient' do
      expect(mail.subject).to eq(
        t('user_mailer.message_reception.subject', from: conv.from.name))
      expect(mail.to).to eq([conv.to.email])
      expect(mail.from).to eq(['notifications@nipanipa.com'])
      expect(mail.body.encoded).to match(conversation_url(conv))
    end
  end
end
