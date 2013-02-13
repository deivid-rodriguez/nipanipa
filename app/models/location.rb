# == Schema Information
#
# Table name: locations
#
#  id        :integer          not null, primary key
#  address   :string(255)
#  latitude  :float
#  longitude :float
#

class Location < ActiveRecord::Base
  attr_protected :latitude, :longitude

  validates :address, uniqueness: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  has_many :users
end
