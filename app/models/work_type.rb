# frozen_string_literal: true

#
# Represents a job category
#
class WorkType < ApplicationRecord
  has_many :sectorizations
  has_many :users, through: :sectorizations

  validates :name, presence: true

  def to_s
    I18n.t("work_types.#{name}")
  end
end
