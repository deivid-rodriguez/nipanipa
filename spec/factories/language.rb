# frozen_string_literal: true

FactoryBot.define do
  factory :language do
    code "en"

    initialize_with { Language.find_or_create_by(code: code) }
  end

  factory :language_skill do
    association :user, factory: :host
    association :language
    level :intermediate
  end
end
