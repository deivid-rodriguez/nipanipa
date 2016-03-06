# frozen_string_literal: true

#
# A language to communicate with people
#
class Language < ActiveRecord::Base
  validates :code, presence: true, uniqueness: true

  has_many :language_skills
  has_many :users, through: :language_skills

  def to_s
    I18n.t(code).mb_chars.titleize.to_s
  end
end
