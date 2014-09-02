class MoveSectorizationsFromUsersToOffers < ActiveRecord::Migration
  def change
    rename_column :sectorizations, :user_id, :offer_id
  end
end
