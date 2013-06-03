class AddRoleToUsers < ActiveRecord::Migration
  def up
    add_column    :users, :role , :string, default: "non-admin"
    remove_column :users, :admin
  end

  def down
    add_column    :users, :admin, :boolean, default: false
    remove_column :users, :role
  end
end
