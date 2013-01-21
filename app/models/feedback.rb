class Feedback < ActiveRecord::Base
  attr_accessible :content, :score

  validates    :sender_id, presence: true, uniqueness: { scope: :recipient_id }
  validates :recipient_id, presence: true
  validates      :content, presence: true, length: { maximum: 140 }

  belongs_to :sender   , class_name: 'User'
  belongs_to :recipient, class_name: 'User'
end
