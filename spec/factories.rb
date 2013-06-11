FactoryGirl.define do

  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "nipanipa.test+user#{n}@gmail.com" }
    password 'foobar'
    description 'I am a test user. I live in a little house in the countryside'

    # simulate first login
    last_sign_in_at { Time.now }
    last_sign_in_ip ENV['IP']
    current_sign_in_at { Time.now}
    current_sign_in_ip ENV['IP']
    sign_in_count 1

    factory :admin do
      role 'admin'
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
    password 'foobar'
    description 'I am a test volunteer. I live in a big city full of noise' \
                'and pollution'
    skills 'What can you do? What kind of tasks are you good at?'

    trait :with_work_type do
      after(:build) do |v|
        v.work_types << FactoryGirl.build(:work_type)
      end
      before(:create) do |v|
        v.work_types.each { |wt| wt.save! }
      end
    end

    trait :with_language do
      after(:build) do |v|
        v.languages << FactoryGirl.buid(:language)
      end
      before(:create) do |v|
        v.languages.each { |l| l.save! }
      end
    end
  end

  factory :host do
    sequence(:name) { |n| "Host #{n}" }
    sequence(:email) { |n| "nipanipa.test+host#{n}@gmail.com" }
    password 'foobar'
    description 'I am a test host. I live in a little house in the countryside'
    skills 'This is supposed to be a longer text to describe the '        \
           'volunteering What is the job going to be like? What kind of ' \
           'tasks do you need to get done?'
    accomodation 'The kind of accomodation you will be providing your ' \
                 'volunteers.'
    hours_per_day 4
    days_per_week 5
    min_stay 1

    trait :with_work_type do
      after(:build) do |h|
        h.work_types << FactoryGirl.build(:work_type)
      end
      before(:create) do |h|
        h.work_types.each { |wt| wt.save! }
      end
    end

    trait :with_language do
      after(:build) do |h|
        h.languages << FactoryGirl.buid(:language)
      end
      before(:create) do |h|
        h.languages.each { |l| l.save! }
      end
    end
  end

  factory :conversation do
    subject 'This is a sample subject'
    association :from, factory: :volunteer
    association :to, factory: :host
    status 'pending'
    after(:build) do |c|
      c.messages.build(body: 'This is a sample body', to_id: c.to.id, from_id: c.from.id)
    end
    after(:create) do |c|
      c.messages.each { |m| m.save! }
    end
  end

  factory :message do
    association :conversation
    body 'This is a sample body'
    association :from , factory: :volunteer
    association :to, factory: :host
  end

  factory :feedback do
    content 'This is a sample feedback. Don\'t know whether it is good or bad' \
            'because the score is random...'
    score { rand(3)-1 }
    association :sender   , factory: :volunteer
    association :recipient, factory: :host
  end

  factory :work_type do
    name 'Organic Farming'
  end

  factory :sectorization do
    association :user
    association :work_type
  end

  factory :language do
    code 'EN'
    name 'English'
  end

  factory :language_skill do
    association :user
    association :language
  end

  factory :picture do
    picture_file_name 'sample_picture.png'
    picture_content_type 'image/png'
    picture_updated_at { Time.now }
    association :user

    factory :avatar do
      avatar true
    end
  end
end
