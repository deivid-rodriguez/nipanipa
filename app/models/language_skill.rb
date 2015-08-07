#
# Associates language levels and users
#
class LanguageSkill < ActiveRecord::Base
  extend Enumerize
  enumerize :level, in: %i(just_hello beginner intermediate expert native)

  validates :level, presence: true

  belongs_to :user
  validates :user, presence: true

  belongs_to :language
  validates :language, presence: true

  validates :user_id, uniqueness: { scope: :language_id }
end
