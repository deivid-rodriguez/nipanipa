class DeviseCreateAdminUsers < ActiveRecord::Migration
  def up
    create_table :admin_users do |t|
      ## Database authenticatable
      t.string :email, limit: 255, null: false, default: ''
      t.string :encrypted_password, limit: 255, null: false, default: ''

      ## Recoverable
      t.string :reset_password_token, limit: 255
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet :current_sign_in_ip
      t.inet :last_sign_in_ip
    end
  end

  def down
    drop_table :admin_users
  end
end
