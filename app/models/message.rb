class Message < ActiveRecord::Base
  attr_accessible :body, :from_id, :conversation_id, :to_id

  validates :body, length: { minimum: 2, maximum: 500 }
  belongs_to :conversation

  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'
end
