class Location < ActiveRecord::Base
  attr_protected :latitude, :longitude

  validates :address, uniqueness: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  has_many :users
end
