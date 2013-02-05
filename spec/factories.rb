FactoryGirl.define do

  factory :user, aliases: [:sender, :recipient] do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "nipanipa.test+user#{n}@gmail.com" }
    password "foobar"
    password_confirmation { password }
    association :location, strategy: :build
    description "I am a test user. I live in a little house in the countryside"
    work_description "Ofrezco trabajo en casa ayudando con la contruccion de mi
granero"

    factory :admin do
      admin true
    end

    factory :user_location_stubbed do
      association :location, strategy: :build_stubbed
    end

    # user_with_posts will create post data after the user has been created
    #factory :user_with_feedbacks do
    #  # posts_count is declared as an ignored attribute and available in
    #  # attributes on the factory, as well as the callback via the evaluator
    #  ignore do
    #    feedback_count 2
    #  end

    #  # the after(:create) yields two values; the user instance itself and the
    #  # evaluator, which stores all values from the factory, including ignored
    #  # attributes; `create_list`'s second argument is the number of records
    #  # to create and we make sure the user is associated properly to the post
    #  after(:create) do |user, evaluator|
    #    FactoryGirl.create_list(:feedback, evaluator.feedback_count, recipient: user)
    #  end
    #end
  end

  factory :host, :class => Host, parent: User do
   type "Host"
  end

  factory :volunteer, :class => Volunteer, parent: User do
   type "Volunteer"
  end

  factory :work_type do
    name "Organic Farming"
  end

  factory :sectorization do
    association :user
    association :work_type
  end

  factory :feedback do
    content "Lorem ipsum"
    association :sender
    association :recipient
    #sender
    #recipient
    score { rand(3)-1 }
  end

  factory :location do
    address "Madrid"
    initialize_with { Location.find_or_initialize_by_address(address) }
  end

end
