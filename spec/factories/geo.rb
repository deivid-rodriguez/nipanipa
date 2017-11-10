# frozen_string_literal: true

FactoryBot.define do
  factory :region do
    transient { continent nil }

    code "MD"
    name "Comunidad de Madrid"

    country do
      if continent
        FactoryBot.create(:country, continent: continent)
      else
        FactoryBot.create(:country)
      end
    end

    initialize_with do
      Region.find_or_initialize_by(code: code, country: country)
    end
  end

  factory :country do
    code "ES"

    continent

    initialize_with do
      Country.find_or_initialize_by(code: code, continent: continent)
    end
  end

  factory :continent do
    code "EU"

    initialize_with { Continent.find_or_initialize_by(code: code) }
  end
end
