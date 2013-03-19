class AddHostIdToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :host_id, :integer
  end
end
