require 'ffaker'

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    # Create some users
    50.times do |n|
      type = 'user' if n == 0
      type = ['host', 'volunteer'].sample if n > 0
      name  = Faker::Name.name
      email = "nipanipa.test+#{type}#{n}@gmail.com"
      password  = "111111"
      description = Faker::Lorem.paragraph(10)
      ip = Faker::Internet.ip_v4_address
      time = Time.now
      user = type.classify.constantize.new(name: name,
                                           email: email,
                                           password: password,
                                           password_confirmation: password,
                                           description: description)
      user.last_sign_in_ip = ip
      user.last_sign_in_at = time
      user.current_sign_in_ip = ip
      user.current_sign_in_at = time
      user.sign_in_count = 1
      user.role = 'admin' if n == 0
      user.save!
    end

    # Create some feedbacks
    users = User.all
    500.times do
      from_to = (0..99).to_a.sample 2
      feedback = Feedback.new(content: Faker::Lorem.sentence(5), score: rand(3) - 1)
      feedback.sender    = users[from_to[0]]
      feedback.recipient = users[from_to[1]]
      feedback.save
    end

  end
end
