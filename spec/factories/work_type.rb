# frozen_string_literal: true

FactoryBot.define do
  factory :work_type do
    name "wwoofing"

    initialize_with { WorkType.find_or_create_by(name: name) }
  end

  factory :sectorization do
    association :user, factory: :host
    association :work_type
  end
end
