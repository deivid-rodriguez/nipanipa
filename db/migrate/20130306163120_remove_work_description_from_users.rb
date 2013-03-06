class RemoveWorkDescriptionFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :work_description
  end

  def down
    add_column :users, :work_description, :text
  end
end
