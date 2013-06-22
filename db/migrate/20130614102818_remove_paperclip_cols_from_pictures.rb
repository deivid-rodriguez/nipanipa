class RemovePaperclipColsFromPictures < ActiveRecord::Migration
  def change
    remove_column :pictures, :picture_file_name
    remove_column :pictures, :picture_content_type
    remove_column :pictures, :picture_file_size
    remove_column :pictures, :picture_updated_at
  end
end
