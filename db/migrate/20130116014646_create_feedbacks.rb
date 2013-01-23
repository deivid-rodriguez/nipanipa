class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :content
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :score

      t.timestamps
    end
    add_index :feedbacks, [:sender_id   , :updated_at]
    add_index :feedbacks, [:recipient_id, :updated_at]
    add_index :feedbacks, [:sender_id   , :recipient_id], unique: true
  end
end
