# == Schema Information
#
# Table name: work_types
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#

class WorkType < ActiveRecord::Base
  has_many :sectorizations
  has_many :users, through: :sectorizations

  validates :name, presence: true
end
