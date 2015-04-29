#
# A single message between users
#
class Message < ActiveRecord::Base
  validates :body, presence: true, length: { minimum: 2, maximum: 500 }

  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  scope :between, lambda { |uid1, uid2|
    where("(sender_id = #{uid1} AND recipient_id = #{uid2}) OR " \
          "(sender_id = #{uid2} AND recipient_id = #{uid1})")
  }

  scope :involving, lambda { |user|
    where(id: involving_ids(user.id))
      .non_deleted_by(user.id)
      .order(created_at: :desc)
  }

  scope :non_deleted_by, lambda { |uid|
    where("(sender_id = #{uid} AND deleted_by_sender_at IS NULL) OR " \
          "(recipient_id = #{uid} AND deleted_by_recipient_at IS NULL)")
  }

  def self.delete_by(uid)
    update_all <<-SQL
      #{delete_for_user_sql('sender', uid)},
      #{delete_for_user_sql('recipient', uid)}
    SQL

    unscoped do
      delete_all <<-SQL
        deleted_by_sender_at IS NOT NULL AND deleted_by_recipient_at IS NOT NULL
      SQL
    end
  end

  def penpal(user)
    sender == user ? recipient : sender
  end

  def notify_recipient
    UserMailer.message_reception(self).deliver_now
  end

  class << self
    private

    def delete_for_user_sql(col, uid)
      <<-SQL
        deleted_by_#{col}_at = CASE #{col}_id
                               WHEN #{uid} THEN LOCALTIMESTAMP
                               ELSE deleted_by_#{col}_at
                               END
      SQL
    end

    def involving_ids(uid)
      select('max(id)')
        .where("sender_id = #{uid} OR recipient_id = #{uid}")
        .group(penpal_sql(uid))
    end

    def penpal_sql(uid)
      "CASE WHEN sender_id = #{uid} THEN recipient_id ELSE sender_id END"
    end
  end
end
