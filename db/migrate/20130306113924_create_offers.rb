class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :title
      t.text :description
      t.text :accomodation
      t.integer :vacancies
      t.date :start_date
      t.date :end_date
      t.integer :min_stay
      t.integer :hours_per_day
      t.integer :days_per_week

      t.timestamps null: true
    end
  end
end
