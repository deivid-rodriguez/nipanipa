# == Schema Information
#
# Table name: sectorizations
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  work_type_id :integer
#

class Sectorization < ActiveRecord::Base
  belongs_to :user
  belongs_to :work_type
end
