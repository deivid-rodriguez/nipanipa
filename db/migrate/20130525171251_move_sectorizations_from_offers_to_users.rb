class MoveSectorizationsFromOffersToUsers < ActiveRecord::Migration

  def change
    rename_column :sectorizations, :offer_id, :user_id
  end

end
