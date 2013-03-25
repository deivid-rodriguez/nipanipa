class FixFeedbackContentColumnType < ActiveRecord::Migration
  def up
    change_column :feedbacks, :content, :text
  end

  def down
    # Might cause trouble for strings longer than 255 characters
    change_column :feedbacks, :content, :string
  end
end
