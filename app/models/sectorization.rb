# frozen_string_literal: true

#
# Associates job categories and users
#
class Sectorization < ApplicationRecord
  belongs_to :user
  validates :user, presence: true

  belongs_to :work_type
  validates :work_type, presence: true
end
