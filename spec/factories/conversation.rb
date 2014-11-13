FactoryGirl.define do
  factory :conversation do
    subject 'This is a sample subject'
    association :from, factory: :volunteer
    association :to, factory: :host
    status 'pending'
    after(:build) do |c|
      c.messages.build(body: 'Sample body', to_id: c.to.id, from_id: c.from.id)
    end

    after(:create) { |c| c.messages.each(&:save!) }
  end

  factory :message do
    conversation
    body 'Sample body'
    association :from, factory: :volunteer
    association :to, factory: :host
  end
end
