# frozen_string_literal: true

#
# Represents a continent.
#
class Continent < ApplicationRecord
  validates :code, presence: true, uniqueness: true

  has_many :countries, dependent: :destroy

  def name
    I18n.t("continents.#{code.downcase}")
  end
end
