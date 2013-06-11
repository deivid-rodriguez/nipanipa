class Feedback < ActiveRecord::Base
  attr_accessible :content, :score

  validates    :sender_id, presence: true, uniqueness: { scope: :recipient_id }
  validates :recipient_id, presence: true
  validates      :content, presence: true, length: { maximum: 300 }

  belongs_to :sender   , class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  before_save :update_karma
  before_destroy :remove_karma

  def complement
    Feedback.find_by_sender_id_and_recipient_id(self.recipient_id, self.sender_id)
  end

  def update_karma
    if new_record?
      recipient.karma += score
    elsif score_changed?
      recipient.karma += (score - score_was)
    end
  end

  def remove_karma
    recipient.karma -= score
  end
end
