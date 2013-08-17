class Conversation < ActiveRecord::Base
  attr_accessible :from_id, :messages_attributes, :status, :subject, :to_id

  validates :subject, presence: true, length: { minimum: 2, maximum: 72 }

  has_many :messages, dependent: :destroy
  accepts_nested_attributes_for :messages

  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'

  scope :deleted_by_sender   , where(deleted_from: false)
  scope :deleted_by_recipient, where(deleted_to: false)

  def mark_as_deleted(user)
    if user == self.from
      self.deleted_from = true
    else
      self.deleted_to = true
    end
    self.save!
  end

  def deleted_by_both?
    self.deleted_from && self.deleted_to
  end

  def reset_deleted_marks
    self.deleted_from = self.deleted_to = false
  end
end
