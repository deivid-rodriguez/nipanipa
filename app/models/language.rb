# frozen_string_literal: true

#
# A language to communicate with people
#
class Language < ApplicationRecord
  validates :code, presence: true, uniqueness: true

  has_many :language_skills, dependent: :destroy, inverse_of: :language
  has_many :users, through: :language_skills, inverse_of: :languages

  def to_s
    I18n.t("languages.#{code}").mb_chars.titleize.to_s
  end
end
