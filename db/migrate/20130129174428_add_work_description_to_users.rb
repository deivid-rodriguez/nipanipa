class AddWorkDescriptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :work_description, :text
  end
end
