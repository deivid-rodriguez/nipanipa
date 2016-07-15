class FixTypoInAccommodationColumn < ActiveRecord::Migration
  def change
    rename_column :users, :accomodation, :accommodation
  end
end
