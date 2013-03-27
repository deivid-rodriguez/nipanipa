class Conversation < ActiveRecord::Base
  attr_accessible :from_id, :messages_attributes, :offer_id, :status, :subject,
                  :to_id

  validates :subject, presence: true, length: { minimum: 2 }

  has_many :messages, dependent: :destroy
  accepts_nested_attributes_for :messages

  belongs_to :offer

  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'
end
