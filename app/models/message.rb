class Message < ActiveRecord::Base
  attr_accessible :body, :from_id, :conversation_id, :to_id

  belongs_to :conversation

  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'
end
