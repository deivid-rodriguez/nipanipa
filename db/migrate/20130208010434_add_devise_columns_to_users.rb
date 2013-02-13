class AddDeviseColumnsToUsers < ActiveRecord::Migration

  def up
    change_column :users, :email,              :string, null: false, default: ""
    add_column    :users, :encrypted_password, :string, null: false, default: ""
    add_column    :users, :remember_created_at, :datetime
    remove_index  :users, :remember_token
    remove_column :users, :password_digest
    remove_column :users, :remember_token
  end

  def down
    add_column    :users, :remember_token      , :string
    add_column    :users, :password_digest     , :string
    add_index     :users, :remember_token
    remove_column :users, :remember_created_at
    remove_column :users, :encrypted_password
    change_column :users, :email               , :string
  end

end
