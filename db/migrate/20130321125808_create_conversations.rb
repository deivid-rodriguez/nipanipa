class CreateConversations < ActiveRecord::Migration
  def self.up
    create_table :conversations do |t|
      t.string :subject
      t.integer :from_id
      t.integer :to_id
      t.integer :offer_id
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :conversations
  end
end
