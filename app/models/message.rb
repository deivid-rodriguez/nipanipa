#
# A single message between users
#
class Message < ActiveRecord::Base
  validates :body, length: { minimum: 2, maximum: 500 }
  belongs_to :conversation

  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'

  after_create :send_message_notification

  private

  def send_message_notification
    UserMailer.message_reception(self).deliver_now
  end
end
