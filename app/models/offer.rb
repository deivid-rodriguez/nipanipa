class Offer < ActiveRecord::Base
  attr_accessible :accomodation, :days_per_week, :description, :end_date,
                  :hours_per_day, :min_stay, :max_candidates, :start_date, :title, :vacancies

  validates :accomodation, presence: true
  validates :description, presence: true
  validates :title, presence: true
  validates :vacancies, presence: true

  belongs_to :host
  has_many :canditates, class_name: 'Volunteer'

  has_many :sectorizations
  has_many :work_types, through: :sectorizations

  def available?
    start_date <= Time.now && end_date >= Time.now
  end
end
