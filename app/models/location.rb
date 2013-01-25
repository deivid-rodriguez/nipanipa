class Location < ActiveRecord::Base
  attr_protected :latitude, :longitude

  geocoded_by :address

  after_validation :geocode, if: :address_changed?

  has_many :users
end
