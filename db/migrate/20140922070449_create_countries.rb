class CreateCountries < ActiveRecord::Migration
  def change
    create_table :continents do |t|
      t.string :code

      t.timestamps
      t.index :code, unique: true
    end

    create_table :countries do |t|
      t.string :code
      t.integer :continent_id, index: true

      t.timestamps
      t.index :code, unique: true
    end

    reversible do |direction|
      direction.up { Rake::Task['db:geo:countries'].invoke }
    end
  end
end
