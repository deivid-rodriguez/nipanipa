class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :content
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :score

      t.timestamps
    end
  end
end
