namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    # Create admin user0
    admin = User.create!(name: "User0",
                         email: "nipanipa.test+user0@gmail.com",
                         password: "foobar",
                         password_confirmation: "foobar",
                         description: "I am the big admin of the site!")
    admin.toggle!(:admin)

    # Create some users
    99.times do |n|
      name  = Faker::Name.name
      email = "nipanipa.test+user#{n+1}@gmail.com"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   description: "I am the sample user #{n+1} for NiPaNiPa")
    end

    # Create some feedbacks
    users = User.all
    1000.times do
      from_to = (0..99).to_a.sample 2
      feedback = Feedback.new(content: Faker::Lorem.sentence(5), score: rand(3) - 1)
      feedback.sender    = users[from_to[0]]
      feedback.recipient = users[from_to[1]]
      feedback.save
    end

  end
end
