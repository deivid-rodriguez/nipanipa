class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :code, limit: 255
      t.string :name, limit: 255
      t.integer :country_id, index: true

      t.timestamps null: true
      t.index [:code, :country_id], unique: true
    end
  end
end
