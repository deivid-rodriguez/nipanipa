class CreateDonations < ActiveRecord::Migration
  def self.up
    create_table :donations do |t|
      t.integer :user_id
      t.decimal :amount
      t.timestamps
    end
  end

  def self.down
    drop_table :donations
  end
end
