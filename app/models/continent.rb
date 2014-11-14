#
# Represents a continent.
#
class Continent < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true

  has_many :countries, dependent: :destroy
end