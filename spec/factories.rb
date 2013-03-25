FactoryGirl.define do

  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "nipanipa.test+user#{n}@gmail.com" }
    password "foobar"
    description "I am a test user. I live in a little house in the countryside"

    # simulate first login
    last_sign_in_at { Time.now }
    last_sign_in_ip ENV["IP"]
    current_sign_in_at { Time.now}
    current_sign_in_ip ENV["IP"]
    sign_in_count 1

    factory :admin do
      role "admin"
    end

    trait :with_feedbacks do
      ignore do
        count 1
      end
      after(:create) do |u, eval|
        FactoryGirl.create_list(:feedback, eval.count, recipient: u)
      end
    end
  end

  factory :volunteer do
    sequence(:name) { |n| "Volunteer #{n}" }
    sequence(:email) { |n| "nipanipa.test+volunteer#{n}@gmail.com" }
    password "foobar"
    description "I am a test host. I live in a little house in the countryside"
  end

  factory :host do
    sequence(:name) { |n| "Host #{n}" }
    sequence(:email) { |n| "nipanipa.test+host#{n}@gmail.com" }
    password "foobar"
    description "I am a test volunteer. I live in a big city full of noise" \
                "and pollution"

    trait :with_offers do
      ignore do
        count 1
      end
      after(:create) do |h, eval|
        FactoryGirl.create_list(:offer, eval.count, host: h)
      end
    end

    factory :active_host, traits: [:with_offers]
  end

  factory :offer do
    title "This is a sample job/volunteer/callitX offer"
    description "This is supposed to be a longer text to describe the offer. " \
                "What is the job going like? What kind of tasks do you need "  \
                "to get done?"
    accomodation "This will describe the accomodation"
    vacancies 1

    trait :complete do
      hours_per_day 4
      days_per_week 5
      min_stay 1
    end

    trait :open do
      start_date { Time.now }
      end_date nil
    end

    trait :active do
      start_date { Time.now }
      end_date { start_date + 3.months }
    end

    trait :inactive do
      start_date { 1.month.from_now }
      end_date { start_date + 3.months }
    end

    trait :expired do
      end_date { Time.now - 1.month }
      start_date { end_date - 3.months }
    end

    trait :with_work_type do
      after(:build) do |o|
        o.work_types << FactoryGirl.build(:work_type)
      end
      before(:create) do |o|
        o.work_types.each { |wt| wt.save! }
      end
    end
  end

  factory :feedback do
    content "This is a sample feedback. Don't know whether it is good or bad" \
            "because the score is random..."
    score { rand(3)-1 }
    association :sender   , factory: :volunteer
    association :recipient, factory: :host
  end

  factory :work_type do
    name "Organic Farming"
  end

  factory :sectorization do
    association :offer
    association :work_type
  end

end
