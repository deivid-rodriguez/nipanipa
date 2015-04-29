FactoryGirl.define do
  factory :message do
    body 'Sample body'
    association :sender, factory: :volunteer
    association :recipient, factory: :host

    trait(:deleted_by_sender) do
      deleted_by_sender_at { Time.zone.now }
    end
  end
end
