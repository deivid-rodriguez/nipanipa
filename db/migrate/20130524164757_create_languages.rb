class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :code, limit: 2
      t.string :name, limit: 255
    end
  end
end
