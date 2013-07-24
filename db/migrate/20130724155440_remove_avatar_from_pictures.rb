class RemoveAvatarFromPictures < ActiveRecord::Migration
  def up
    remove_column :pictures, :avatar
  end

  def down
    add_column :pictures, :avatar, :boolean
  end
end
