FactoryGirl.define do
  factory :feedback do
    content 'This is a sample feedback.'
    score :neutral
    association :sender, factory: :volunteer
    association :recipient, factory: :host
  end
end
