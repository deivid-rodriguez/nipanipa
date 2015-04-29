class WhatsappStyleMessages < ActiveRecord::Migration
  def up
    change_table :messages do |t|
      t.datetime :deleted_by_sender_at
      t.datetime :deleted_by_recipient_at
      t.rename :from_id, :sender_id
      t.rename :to_id, :recipient_id
    end

    execute <<-SQL
      UPDATE messages m
      SET deleted_by_sender_at = #{bool_to_datetime_sql('deleted_from')},
          deleted_by_recipient_at = #{bool_to_datetime_sql('deleted_to')}
      FROM conversations c
      WHERE m.conversation_id = c.id
    SQL

    remove_column :messages, :conversation_id

    drop_table :conversations
  end

  def down
    create_table :conversations do |t|
      t.string :subject
      t.integer :from_id
      t.integer :to_id
      t.string :status
      t.datetime :created_at
      t.datetime :updated_at
      t.boolean :deleted_from, default: false
      t.boolean :deleted_to, default: false
    end

    add_column :messages, :conversation_id, :integer

    execute <<-SQL
      INSERT INTO conversations(#{inserted_cols_sql})
      SELECT #{selected_cols_sql}
      FROM messages
      GROUP BY sender_id, recipient_id
    SQL

    change_table :messages do |t|
      t.rename :recipient_id, :to_id
      t.rename :sender_id, :from_id
      t.remove :deleted_by_recipient_at
      t.remove :deleted_by_sender_at
    end
  end

  private

  def inserted_cols_sql
    'subject, from_id, to_id, created_at, updated_at, deleted_from, deleted_to'
  end

  def selected_cols_sql
    <<-SQL
      'Conversation between ' || sender_id || ' and ' || recipient_id,
      sender_id,
      recipient_id,
      MIN(created_at),
      MIN(updated_at),
      BOOL_OR(#{datetime_to_bool_sql('deleted_by_sender_at')}),
      BOOL_OR(#{datetime_to_bool_sql('deleted_by_recipient_at')})
    SQL
  end

  def bool_to_datetime_sql(col)
    "CASE #{col} WHEN true THEN LOCALTIMESTAMP END"
  end

  def datetime_to_bool_sql(col)
    "CASE WHEN #{col} IS NULL THEN false ELSE true END"
  end
end
