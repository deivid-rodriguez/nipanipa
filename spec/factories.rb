FactoryGirl.define do

  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "nipanipa.test+user#{n}@gmail.com" }
    password "foobar"
    description "I am a test user. I live in a little house in the countryside"
    work_description "Ofrezco trabajo en casa ayudando con la contruccion de mi
granero"
    location

    factory :admin do
      role "admin"
    end
  end

  factory :host, class: Host, parent: :user do
    type "Host"
  end

  factory :volunteer, class: Volunteer, parent: :user do
    type "Volunteer"
  end

  factory :host_with_work_type, parent: :host do
    after(:create) do |u|
      u.work_types << FactoryGirl.create(:work_type)
    end
  end

  factory :user_with_work_type, parent: :user do
    after(:build) do |u|
      u.work_types << FactoryGirl.build(:work_type)
    end
    before(:create) do |u|
      u.work_types.each { |wt| wt.save! }
    end
  end

  factory :feedback do
    content "Lorem ipsum"
    score { rand(3)-1 }
    association :sender   , factory: :volunteer
    association :recipient, factory: :host
  end

  factory :user_with_feedbacks, parent: :user do
    ignore do
      count 1
    end
    after(:create) do |u, eval|
      FactoryGirl.create_list(:feedback, eval.count, recipient: u)
    end
  end

  factory :work_type do
    name "Organic Farming"
  end

  factory :sectorization do
    association :user
    association :work_type
  end

  factory :location do
    address "Madrid"
    initialize_with { Location.find_or_initialize_by_address(address) }
  end

end
