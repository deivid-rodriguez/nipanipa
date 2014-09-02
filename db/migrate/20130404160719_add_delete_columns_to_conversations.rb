class AddDeleteColumnsToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :deleted_from, :boolean, default: false
    add_column :conversations, :deleted_to, :boolean, default: false
  end
end
