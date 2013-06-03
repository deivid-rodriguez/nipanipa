class AddOffersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :accomodation, :text
    add_column :users, :skills, :text
    add_column :users, :min_stay, :integer
    add_column :users, :hours_per_day, :integer
    add_column :users, :days_per_week, :integer
  end
end
