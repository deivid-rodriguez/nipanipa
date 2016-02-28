# frozen_string_literal: true

#
# Represents a first level region in a country.
#
class Region < ActiveRecord::Base
  validates :code, presence: true

  belongs_to :country
  validates :country, presence: true

  validates :code, uniqueness: { scope: :country_id }

  has_many :users

  def self.default
    find_by(code: "MD")
  end
end
