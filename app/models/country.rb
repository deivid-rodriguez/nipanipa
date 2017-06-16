# frozen_string_literal: true

#
# Represents a country
#
class Country < ApplicationRecord
  validates :code, presence: true, uniqueness: true

  belongs_to :continent
  validates :continent, presence: true

  has_many :regions, dependent: :destroy
  accepts_nested_attributes_for :regions, allow_destroy: true

  def self.default
    find_by(code: "ES")
  end

  def self.options
    all.sort_by(&:name)
  end

  default_scope { includes(:continent) }

  scope :with_users, -> { joins(regions: :users).distinct }

  has_many :users, through: :regions

  def name
    I18n.t("countries.#{continent.code.downcase}.#{code.downcase}")
  end
end
