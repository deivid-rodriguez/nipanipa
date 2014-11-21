class RemoveCountryAndStateAndLatitudeAndLongitudeFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :country, :string
    remove_column :users, :state, :string
    remove_column :users, :latitude, :float
    remove_column :users, :longitude, :float
  end
end
