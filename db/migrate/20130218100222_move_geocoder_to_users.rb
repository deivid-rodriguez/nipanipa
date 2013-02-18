class MoveGeocoderToUsers < ActiveRecord::Migration

  def up
    add_column :users, :state    , :string
    add_column :users, :country  , :string
    add_column :users, :latitude , :float
    add_column :users, :longitude, :float
    add_index :users, [:latitude, :longitude]
    remove_column :users, :location_id
    drop_table :locations
  end

  def down
    create_table :locations do |t|
      t.string :address
      t.float  :latitude
      t.float  :longitude
    end
    add_column :users, :location_id, :integer
    remove_index :users, [:latitude, :longitude]
    remove_column :users, :longitude
    remove_column :users, :latitude
    remove_column :users, :country
    remove_column :users, :state
  end

end
