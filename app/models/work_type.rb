class WorkType < ActiveRecord::Base
  attr_accessible :name

  has_many :sectorizations
  has_many :users, through: :sectorizations

  validates :name, presence: true
end
