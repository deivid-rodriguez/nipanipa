class AddAvatarToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :avatar, :boolean, default: false
  end
end
