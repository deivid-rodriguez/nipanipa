# == Schema Information
#
# Table name: sectorizations
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  work_type_id :integer
#

class Sectorization < ActiveRecord::Base
  belongs_to :offer
  belongs_to :work_type
end
