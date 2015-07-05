class AddTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :type, :string, limit: 255
  end
end
