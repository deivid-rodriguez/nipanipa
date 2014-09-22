class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :code
      t.string :name
      t.integer :country_id, index: true

      t.timestamps
      t.index [:code, :country_id], unique: true
    end

    reversible do |direction|
      direction.up { Rake::Task['db:geo:regions'].invoke }
    end
  end
end
