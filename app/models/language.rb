#
# A language to communicate with people
#
class Language < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true

  has_many :language_skills
  has_many :users, through: :language_skills
end
