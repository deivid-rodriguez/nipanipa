class AddAdminAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin_at, :datetime
  end
end
