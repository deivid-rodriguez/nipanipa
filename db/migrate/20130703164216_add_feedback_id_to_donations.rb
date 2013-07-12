class AddFeedbackIdToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :feedback_id, :integer
  end
end
