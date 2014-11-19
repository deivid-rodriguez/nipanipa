#
# Conversation between 2 users
#
class Conversation < ActiveRecord::Base
  validates :subject, presence: true, length: { minimum: 2, maximum: 72 }

  has_many :messages, dependent: :destroy
  accepts_nested_attributes_for :messages

  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'

  default_scope { order(updated_at: :desc) }

  def self.non_deleted(user)
    where("(from_id = #{user.id} AND deleted_from = false) OR " \
          "(to_id = #{user.id} AND deleted_to = false)")
  end

  def mark_as_deleted(user)
    if user == from
      self.deleted_from = true
    else
      self.deleted_to = true
    end
    self.save!
  end

  def deleted_by_both?
    deleted_from && deleted_to
  end

  def reset_deleted_marks
    self.deleted_from = self.deleted_to = false
  end
end
