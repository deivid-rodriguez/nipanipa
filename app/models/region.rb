class Region < ActiveRecord::Base
  validates :code, presence: true

  belongs_to :country
  validates :country, presence: true

  validates :code, uniqueness: { scope: :country_id }
end
