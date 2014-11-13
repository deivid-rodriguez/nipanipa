FactoryGirl.define do
  factory :work_type do
    sequence(:name) { |n| "Work Type #{n % 15}" }
  end

  factory :sectorization do
    association :user, factory: :host
    association :work_type
  end
end
