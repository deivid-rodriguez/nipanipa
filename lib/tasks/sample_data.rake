namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "User0",
                         email: "nipanipa.test+user0@gmail.com",
                         password: "foobar",
                         password_confirmation: "foobar")
    admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "nipanipa.test+user#{n+1}@gmail.com"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
    users = User.all
    3000.times do
      from_to = (0..99).to_a.sample 2
      feedback = Feedback.new(content: Faker::Lorem.sentence(5), score: rand(3) - 1)
      feedback.sender    = users[from_to[0]]
      feedback.recipient = users[from_to[1]]
      feedback.save
    end
  end
end
