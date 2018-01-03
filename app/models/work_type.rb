# frozen_string_literal: true

#
# Represents a job category
#
class WorkType < ApplicationRecord
  has_many :sectorizations, dependent: :destroy
  has_many :users, through: :sectorizations, inverse_of: :work_type

  validates :name, presence: true

  def to_s
    I18n.t("work_types.#{name}")
  end
end
