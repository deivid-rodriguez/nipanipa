namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    # Generates a random biased score
    def rand_score
      num = rand(10)
      return :positive if (0..6).cover?(num)
      return :neutral if (7..8).cover?(num)
      :negative
    end

    def rand_work_type_ids
      (1..@n_work_types).to_a.sample rand(3)
    end

    @n_users = 50
    @n_work_types = WorkType.all.size
    @n_languages = Language.all.size

    # Create some users
    @n_users.times do |n|
      type = ['host', 'volunteer'].sample
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
      user.work_type_ids = rand_work_type_ids
      user.skills = Faker::Lorem.paragraph(11)
      user.accomodation = Faker::Lorem.paragraph(8) if user.type == 'Host'
      user.role = 'admin' if n == 0
      user.save!
    end

    # Create some feedbacks
    users = User.all
    250.times do
      from_to = (1..@n_users).to_a.sample 2
      loop do
        break if Feedback.where(sender_id: from_to[0],
                                recipient_id: from_to[1]).empty?
        from_to = (1..@n_users).to_a.sample 2
      end
      feedback = Feedback.new content: Faker::Lorem.sentence(5),
                              score: rand_score
      feedback.sender_id = from_to[0]
      feedback.recipient_id = from_to[1]
      feedback.recipient.karma += feedback.score.value
      feedback.recipient.save!
      feedback.save!
    end

    # Create some language skills
    100.times do
      user = (1..@n_users).to_a.shuffle[0]
      lang = (1..@n_languages).to_a.shuffle[0]
      loop do
        break if LanguageSkill.where(language_id: lang, user_id: user).empty?
        user = (1..@n_users).to_a.shuffle[0]
        lang = (1..@n_languages).to_a.shuffle[0]
      end
      language_skill =
        LanguageSkill.new language_id: lang, user_id: user,
                          level: LanguageSkill.level.values[rand(5)]
      language_skill.save!
    end

  end
end
