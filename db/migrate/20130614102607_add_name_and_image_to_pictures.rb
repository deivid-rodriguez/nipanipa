class AddNameAndImageToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :name, :string
    add_column :pictures, :image, :string
  end
end
