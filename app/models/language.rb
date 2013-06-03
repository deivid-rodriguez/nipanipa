class Language < ActiveRecord::Base
  attr_accessible :name

  has_many :language_skills
  has_many :users, through: :language_skills

  def to_s
    name
  end
end
