#
# Represents a country
#
class Country < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true

  belongs_to :continent
  validates :continent, presence: true

  has_many :regions

  def self.find_by_code_and_continent_code(c, cc)
    countries = includes(:continent).where(code: c, continents: { code: cc })
    fail 'Inconsistent Database' if countries.size > 1

    countries.first
  end

  has_many :users, through: :regions
end
