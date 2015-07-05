class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :code, limit: 255
      t.string :name, limit: 255
      t.integer :country_id, index: true

      t.timestamps null: true
      t.index [:code, :country_id], unique: true
    end

    if Rails.env.production?
      reversible do |direction|
        direction.up { Rake::Task['db:maxmind:regions'].invoke }
      end
    end
  end
end
