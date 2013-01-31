FactoryGirl.define do

  factory :user, aliases: [:sender, :recipient] do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "nipanipa.test+user#{n}@gmail.com" }
    password "foobar"
    password_confirmation { password }
    location
    description "I am a test user. I live in a little house in the countryside"
    work_description "Ofrezco trabajo en casa ayudando con la contruccion de mi
                      granero"

    factory :admin do
      admin true
    end
  end

  factory :feedback do
    content "Lorem ipsum"
    sender
    recipient
    score { rand(3)-1 }
  end

  factory :location do
    address "Madrid"
    initialize_with { Location.find_or_initialize_by_address(address) }
    after(:build) do |loc|
      #loc.stub(:geocode).and_return [1,1]
      VCR.use_cassette('location', record: :new_episodes) do
        loc.geocode
      end
    end
  end

end
