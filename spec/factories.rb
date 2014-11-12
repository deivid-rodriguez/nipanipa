FactoryGirl.define do

  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "nipanipa.test+user#{n}@gmail.com" }
    password 'foobar'
    availability { %w(jan feb mar apr may jun jul aug sep oct nov dic) }

    # simulate first login
    last_sign_in_at { Time.now }
    last_sign_in_ip ENV['FAKE_IP']
    current_sign_in_at { Time.now }
    current_sign_in_ip ENV['FAKE_IP']
    sign_in_count 1

    trait :available_just_now do
      availability { [DateTime.now.strftime('%b').downcase] }
    end

    trait :not_available do
      availability []
    end

    trait :with_work_types do
      transient { count 1 }

      after(:build) do |h, eval|
        eval.count.times do
          h.work_types << FactoryGirl.build(:work_type)
        end
      end

      before(:create) { |h| h.work_types.each(&:save!) }
    end

    trait :with_language do
      after(:build) do |v|
        v.languages << FactoryGirl.build(:language)
      end

      before(:create) { |v| v.languages.each(&:save!) }
    end

    factory :host, class: 'Host' do
      sequence(:name) { |n| "Host #{n}" }
      description 'We are a test host. We live in the countryside in the wild'
      skills 'I need strong healthy people for heavy work'
      accomodation 'Type of accomodation you will be providing your volunteers'
      hours_per_day 4
      days_per_week 5
      min_stay 1
    end

    factory :volunteer, class: 'Volunteer' do
      sequence(:name) { |n| "Volunteer #{n}" }
      description 'I am a test volunteer. I live in a big city full of noise'
      skills 'I am a fast learner and a laid back person'
    end
  end

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
    association :conversation
    body 'Sample body'
    association :from, factory: :volunteer
    association :to, factory: :host
  end

  factory :feedback do
    content 'This is a sample feedback.'
    score :neutral
    association :sender, factory: :volunteer
    association :recipient, factory: :host
  end

  factory :work_type do
    sequence(:name) { |n| "Work Type #{n % 15}" }
  end

  factory :sectorization do
    association :user, factory: :host
    association :work_type
  end

  factory :language do
    sequence(:code) { |n| "L#{n % 10}" }
    sequence(:name) { |n| "Language#{n % 10}" }
  end

  factory :language_skill do
    association :user, factory: :host
    association :language
    level :intermediate
  end

  factory :picture do
    name 'My funny picture'
    image do
      Rack::Test::UploadedFile.new(
              File.join(Rails.root, 'spec', 'fixtures', 'test_img.png'))
    end
    association :user, factory: :host
  end
end
