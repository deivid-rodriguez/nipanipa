class AddNameAndImageToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :name, :string, limit: 255
    add_column :pictures, :image, :string, limit: 255
  end
end
