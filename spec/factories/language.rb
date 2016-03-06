# frozen_string_literal: true

FactoryGirl.define do
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
