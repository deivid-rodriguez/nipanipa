class Language < ActiveRecord::Base
  attr_accessible :name, :code

  has_many :language_skills
  has_many :users, through: :language_skills

  def to_s
    name
  end
end
