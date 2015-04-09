class AddDeviseReconfirmableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    update <<-SQL
      UPDATE users
      SET confirmed_at = '#{DateTime.now}'
    SQL
  end
end
