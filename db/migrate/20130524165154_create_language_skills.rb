class CreateLanguageSkills < ActiveRecord::Migration
  def change
    create_table :language_skills do |t|
      t.integer :user_id
      t.integer :language_id
      t.string :level, limit: 255
    end

    add_index :language_skills, :user_id
    add_index :language_skills, :language_id
    add_index :language_skills, [:user_id, :language_id], unique: true
  end
end
