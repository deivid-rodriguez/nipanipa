class AddRecoverableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :reset_password_token  , :string
  end
end
