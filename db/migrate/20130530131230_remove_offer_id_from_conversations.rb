class RemoveOfferIdFromConversations < ActiveRecord::Migration
  def up
    remove_column :conversations, :offer_id
  end

  def down
    add_column :conversations, :offer_id, :integer
  end
end
