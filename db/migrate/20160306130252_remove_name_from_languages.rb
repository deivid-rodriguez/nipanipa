class RemoveNameFromLanguages < ActiveRecord::Migration
  def change
    remove_column :languages, :name, :string
  end
end
