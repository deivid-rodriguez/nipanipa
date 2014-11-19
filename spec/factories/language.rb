FactoryGirl.define do
  factory :language do
    code 'en'
    name 'English'

    initialize_with do
      Language.create_with(name: name).find_or_create_by(code: code)
    end
  end

  factory :language_skill do
    association :user, factory: :host
    association :language
    level :intermediate
  end
end
