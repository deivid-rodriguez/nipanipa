class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      # paperclip fields
      t.string :picture_file_name
      t.string :picture_content_type
      t.integer :picture_file_size
      t.datetime :picture_updated_at

      t.integer :user_id
    end
  end
end
