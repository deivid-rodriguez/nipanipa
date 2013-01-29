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
    sequence(:address) { |n| "Madrid #{n}" }
  end

end
