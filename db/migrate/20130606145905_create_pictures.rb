class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.attachment :picture
      t.integer :user_id
    end
  end
end
