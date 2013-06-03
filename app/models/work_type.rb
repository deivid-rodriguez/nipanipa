class WorkType < ActiveRecord::Base
  attr_accessible :name

  has_many :sectorizations
  has_many :users, through: :sectorizations

  validates :name, presence: true

  def to_s
    I18n.translate("work_types.#{name}")
  end
end
