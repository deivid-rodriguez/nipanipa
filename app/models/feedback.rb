class Feedback < ActiveRecord::Base

  extend Enumerize
  enumerize :score, in: { negative: -1, neutral: 0, positive: 1 },
                    default: :neutral

  validates    :sender_id, presence: true, uniqueness: { scope: :recipient_id }
  validates :recipient_id, presence: true
  validates      :content, presence: true, length: { maximum: 300 }

  belongs_to :sender   , class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  before_save :update_karma
  before_destroy :remove_karma

  has_one :donation
  accepts_nested_attributes_for :donation,
                                reject_if: proc { |attr| attr[:amount] == "0" }

  scope :sent    , ->(user) { where(sender: user)    }
  scope :received, ->(user) { where(recipient: user) }

  def complement
    Feedback.find_by(sender: recipient, recipient: sender)
  end

  def update_karma
    if new_record?
      if score.value != 0
        recipient.karma += score.value
        recipient.save
      end
    elsif score_changed? and score_was and score.value != score_was
      recipient.karma += (score.value - score_was)
      recipient.save
    end
  end

  def remove_karma
    if score.value != 0
      recipient.karma -= score.value
      recipient.save
    end
  end

  def self.pairs(user)
    result_list  = []
    sent_list = Feedback.sent(user)
    Feedback.received(user).each do |feedback|
      result_list << [feedback, feedback.complement]
      sent_list -= [feedback.complement]
    end
    result_list.concat(sent_list.map { |x| [nil, x] })
  end
end
