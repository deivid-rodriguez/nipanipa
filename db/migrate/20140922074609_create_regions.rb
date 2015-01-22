class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :code
      t.string :name
      t.integer :country_id, index: true

      t.timestamps null: true
      t.index [:code, :country_id], unique: true
    end

    reversible do |direction|
      unless Rails.env.test?
        direction.up { Rake::Task['db:geo:regions'].invoke }
      end
    end
  end
end
