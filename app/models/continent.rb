class Continent < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true

  has_many :countries
end
