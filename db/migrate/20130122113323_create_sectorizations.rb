class CreateSectorizations < ActiveRecord::Migration
  def change
    create_table :sectorizations do |t|
      t.integer :user_id
      t.integer :work_type_id
    end
    add_index :sectorizations, :user_id
    add_index :sectorizations, :work_type_id
    add_index :sectorizations, [:user_id, :work_type_id], unique: true
  end
end
