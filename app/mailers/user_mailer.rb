class UserMailer < ActionMailer::Base
  default from: "notifications@nipanipa.com"

  def message_reception(message)
    @message = message

    mail to: message.to.email,
         subject: t('user_mailer.message_reception.subject', message.from.name)
  end
end
