require 'spec_helper'

describe UserMailer do
  describe 'message_reception' do
    let!(:conv) { create(:conversation) }
    let(:mail) { UserMailer.message_reception(conv.messages.first) }

    it 'sends notification to recpient' do
      mail.subject.should eq(
        t('user_mailer.message_reception.subject', from: conv.from.name))
      mail.to.should eq([conv.to.email])
      mail.from.should eq(['notifications@nipanipa.com'])
      mail.body.encoded.should match(conversation_url(conv))
    end
  end
end
