# == Schema Information
#
# Table name: offers
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  description   :text
#  accomodation  :text
#  vacancies     :integer
#  start_date    :date
#  end_date      :date
#  min_stay      :integer
#  hours_per_day :integer
#  days_per_week :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  host_id       :integer
#

class Offer < ActiveRecord::Base
  attr_accessible :accomodation, :days_per_week, :description, :end_date,
                  :hours_per_day, :min_stay, :max_candidates, :start_date,
                  :title, :vacancies, :work_type_ids

  validates :accomodation, presence: true
  validates :description, presence: true
  validates :title, presence: true
  validates :vacancies, presence: true

  belongs_to :host
  has_many :candidates, class_name: 'Volunteer'

  has_many :sectorizations
  has_many :work_types, through: :sectorizations

  def available?
    start_date <= Time.now && (end_date.nil? || end_date >= Time.now )
  end
end
