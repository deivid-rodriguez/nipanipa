# frozen_string_literal: true

#
# A single message between users
#
class Message < ApplicationRecord
  validates :body, presence: true, length: { minimum: 1, maximum: 500 }

  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  scope :between, ->(uid1, uid2) do
    condition = <<-SQL.squish
      (sender_id = ? AND recipient_id = ?) OR
      (sender_id = ? AND recipient_id = ?)
    SQL

    where(condition, uid1, uid2, uid2, uid1)
  end

  scope :involving, ->(user) do
    where(id: involving_ids(user.id))
      .non_deleted_by(user.id)
      .order(created_at: :desc)
  end

  scope :non_deleted_by, ->(uid) do
    condition = <<-SQL.squish
      (sender_id = ? AND deleted_by_sender_at IS NULL) OR
      (recipient_id = ? AND deleted_by_recipient_at IS NULL)
    SQL

    where(condition, uid, uid)
  end

  def self.delete_by(uid)
    where(sender_id: uid).update(deleted_by_sender_at: Time.zone.now)
    where(recipient_id: uid).update(deleted_by_recipient_at: Time.zone.now)

    unscoped
      .where
      .not(deleted_by_sender_at: nil, deleted_by_recipient_at: nil)
      .delete_all
  end

  def self.sent_or_received_by(uid)
    where("sender_id = ? OR recipient_id = ?", uid, uid)
  end

  def self.involving_ids(uid)
    select("max(id)").sent_or_received_by(uid).group(penpal_sql(uid))
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
