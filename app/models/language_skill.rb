class LanguageSkill < ActiveRecord::Base
  extend Enumerize
  enumerize :level,
            in: [:just_hello, :beginner, :intermediate, :expert, :native]

  validates :level, presence: true

  belongs_to :user
  belongs_to :language
end
