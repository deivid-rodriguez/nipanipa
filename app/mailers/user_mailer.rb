#
# Responsible for sending mails in the app
#
class UserMailer < ActionMailer::Base
  default from: 'notifications@nipanipa.com'

  def message_reception(message)
    @msg = message

    subject = t('user_mailer.message_reception.subject', from: @msg.sender.name)
    mail to: @msg.recipient.email, subject: subject
  end
end
