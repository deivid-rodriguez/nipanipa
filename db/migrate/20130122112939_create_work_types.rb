class CreateWorkTypes < ActiveRecord::Migration
  def change
    create_table :work_types do |t|
      t.string :name, limit: 255
      t.string :description, limit: 255
    end
  end
end
