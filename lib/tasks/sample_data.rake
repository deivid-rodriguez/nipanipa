require 'ffaker'

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    # Generates a random biased score
    def rand_score
      num = rand(10)
      return 1 if (0..6).cover?(num)
      return 0 if (7..8).cover?(num)
      -1
    end

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
      user = type.classify.constantize.new name: name,
                                           email: email,
                                           password: password,
                                           password_confirmation: password,
                                           description: description
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
      from_to = (1..50).to_a.sample 2
      loop do
        break if Feedback.where(sender_id: from_to[0],
                                recipient_id: from_to[1]).empty?
        from_to = (1..50).to_a.sample 2
      end
      feedback = Feedback.new content: Faker::Lorem.sentence(5),
                              score: rand_score
      feedback.sender_id = from_to[0]
      feedback.recipient_id = from_to[1]
      feedback.recipient.karma += feedback.score
      feedback.recipient.save!
      feedback.save!
    end

  end
end
