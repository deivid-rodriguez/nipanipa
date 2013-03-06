class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :title
      t.text :description
      t.text :accomodation
      t.integer :vacancies
      t.datetime :start_date
      t.datetime :end_date
      t.integer :min_stay
      t.integer :hours_per_day
      t.integer :days_per_week

      t.timestamps
    end
  end
end
