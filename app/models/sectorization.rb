# == Schema Information
#
# Table name: sectorizations
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  work_type_id :integer
#

class Sectorization < ActiveRecord::Base
  attr_accessible :work_type_id

  validates :user_id     , presence: true
  validates :work_type_id, presence: true

  belongs_to :user
  belongs_to :work_type
end
