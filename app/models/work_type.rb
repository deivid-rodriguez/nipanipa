#
# Represents a job category
#
class WorkType < ActiveRecord::Base
  has_many :sectorizations
  has_many :users, through: :sectorizations

  validates :name, presence: true
end
