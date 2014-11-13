FactoryGirl.define do
  factory :language do
    sequence(:code) { |n| "L#{n % 10}" }
    sequence(:name) { |n| "Language#{n % 10}" }
  end

  factory :language_skill do
    association :user, factory: :host
    association :language
    level :intermediate
  end
end
