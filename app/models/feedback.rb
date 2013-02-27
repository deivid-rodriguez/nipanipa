# == Schema Information
#
# Table name: feedbacks
#
#  id           :integer          not null, primary key
#  content      :string(255)
#  sender_id    :integer
#  recipient_id :integer
#  score        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Feedback < ActiveRecord::Base
  attr_accessible :content, :score

  validates    :sender_id, presence: true, uniqueness: { scope: :recipient_id }
  validates :recipient_id, presence: true
  validates      :content, presence: true, length: { maximum: 300 }

  belongs_to :sender   , class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  def complement
    Feedback.find_by_sender_id_and_recipient_id(self.recipient_id, self.sender_id)
  end
end
