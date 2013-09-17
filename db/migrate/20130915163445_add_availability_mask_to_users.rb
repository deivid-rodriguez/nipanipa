class AddAvailabilityMaskToUsers < ActiveRecord::Migration
  def change
    add_column :users, :availability_mask, :integer
  end
end
