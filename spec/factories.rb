FactoryGirl.define do

  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "nipanipa.test+user#{n}@gmail.com" }
    password "foobar"
    description "I am a test user. I live in a little house in the countryside"
    work_description "Ofrezco trabajo en casa ayudandome a construir mi granero"

    # simulate first login
    last_sign_in_at { Time.now }
    last_sign_in_ip ENV["IP"]
    current_sign_in_at { Time.now}
    current_sign_in_ip ENV["IP"]
    sign_in_count 1

    factory :admin do
      role "admin"
    end

    factory :user_with_work_type do
      after(:build) do |u|
        u.work_types << FactoryGirl.build(:work_type)
      end
      before(:create) do |u|
        u.work_types.each { |wt| wt.save! }
      end
    end

    factory :user_with_feedbacks do
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
    work_description "Ofrezco trabajo en casa ayudandome a construir mi granero"
  end

  factory :host do
    sequence(:name) { |n| "Host #{n}" }
    sequence(:email) { |n| "nipanipa.test+host#{n}@gmail.com" }
    password "foobar"
    description "I am a test volunteer. I live in a big city full of noise" \
                "and pollution"
    work_description "Ofrezco mi ayuda a cambio de un lugar pa dormir"

    factory :host_with_work_type do
      after(:create) do |u|
        u.work_types << FactoryGirl.create(:work_type)
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
    association :user
    association :work_type
  end

end
