class CreateCountries < ActiveRecord::Migration
  def change
    create_table :continents do |t|
      t.string :code, limit: 255

      t.timestamps null: true
      t.index :code, unique: true
    end

    create_table :countries do |t|
      t.string :code, limit: 255
      t.integer :continent_id, index: true

      t.timestamps null: true
      t.index :code, unique: true
    end
  end
end
