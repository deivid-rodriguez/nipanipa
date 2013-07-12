class SetDonationAmountPrecisionAndScale < ActiveRecord::Migration
  def change
    change_column :donations, :amount, :decimal, precision: 4, scale: 2
  end
end
