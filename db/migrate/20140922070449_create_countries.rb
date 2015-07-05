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

    if Rails.env.production?
      reversible do |direction|
        direction.up { Rake::Task['db:maxmind:countries'].invoke }
      end
    end
  end
end
