#
# Responsible for sending mails in the app
#
class UserMailer < ActionMailer::Base
  default from: 'notifications@nipanipa.com'

  def message_reception(message)
    @msg = message

    mail to: @msg.to.email, subject: t('user_mailer.message_reception.subject',
                                       from: @msg.from.name)
  end
end
