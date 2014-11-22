#
# Represents a country
#
class Country < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true

  belongs_to :continent
  validates :continent, presence: true

  has_many :regions, dependent: :destroy
  accepts_nested_attributes_for :regions, allow_destroy: true

  def self.find_by_code_and_continent_code(c, cc)
    countries = includes(:continent).where(code: c, continents: { code: cc })
    fail 'Inconsistent Database' if countries.size > 1

    countries.first
  end

  default_scope { includes(:continent) }

  scope :with_users, -> { joins(regions: :users).uniq }

  has_many :users, through: :regions

  def name
    I18n.t("countries.#{continent.code.downcase}.#{code.downcase}")
  end
end
