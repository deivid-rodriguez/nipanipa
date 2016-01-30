#
# A single message between users
#
class Message < ActiveRecord::Base
  validates :body, presence: true, length: { minimum: 2, maximum: 500 }

  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  scope :between, lambda { |uid1, uid2|
    condition = <<-SQL.squish
      (sender_id = ? AND recipient_id = ?) OR
      (sender_id = ? AND recipient_id = ?)
    SQL

    where(condition, uid1, uid2, uid2, uid1)
  }

  scope :involving, lambda { |user|
    where(id: involving_ids(user.id))
      .non_deleted_by(user.id)
      .order(created_at: :desc)
  }

  scope :non_deleted_by, lambda { |uid|
    condition = <<-SQL.squish
      (sender_id = ? AND deleted_by_sender_at IS NULL) OR
      (recipient_id = ? AND deleted_by_recipient_at IS NULL)
    SQL

    where(condition, uid, uid)
  }

  def self.delete_by(uid)
    where(sender_id: uid).update_all(deleted_by_sender_at: Time.zone.now)
    where(recipient_id: uid).update_all(deleted_by_recipient_at: Time.zone.now)

    unscoped do
      delete_all <<-SQL
        deleted_by_sender_at IS NOT NULL AND deleted_by_recipient_at IS NOT NULL
      SQL
    end
  end

  def self.sent_or_received_by(uid)
    where('sender_id = ? OR recipient_id = ?', uid, uid)
  end

  def self.involving_ids(uid)
    select('max(id)').sent_or_received_by(uid).group(penpal_sql(uid))
  end

  def penpal(user)
    sender == user ? recipient : sender
  end

  def notify_recipient
    UserMailer.message_reception(self).deliver_now
  end

  class << self
    private

    def penpal_sql(uid)
      "CASE WHEN sender_id = #{uid} THEN recipient_id ELSE sender_id END"
    end
  end
end
