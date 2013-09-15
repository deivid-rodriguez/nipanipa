class Language < ActiveRecord::Base
  has_many :language_skills
  has_many :users, through: :language_skills
end
