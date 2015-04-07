namespace :db do
  #
  # Generates a random biased score
  #
  def rand_score
    num = rand(10)
    return :positive if (0..6).cover?(num)
    return :neutral if (7..8).cover?(num)
    :negative
  end

  #
  # Creates +n+ users
  #
  def create_users(n)
    n.times do |i|
      type = %w(host volunteer).sample
      user = type.classify.constantize.new \
        name: FFaker::Name.name,
        email: "#{type}#{i}@example.com",
        password: '111111',
        password_confirmation: '111111',
        description: FFaker::Lorem.paragraph(10),
        region: Region.limit(1).order('RANDOM()').first

      user.last_sign_in_at = Time.zone.now
      user.current_sign_in_at = Time.zone.now
      user.sign_in_count = 1
      user.work_type_ids = (1..WorkType.count).to_a.sample(rand(3))
      user.skills = FFaker::Lorem.paragraph(11)
      user.accomodation = FFaker::Lorem.paragraph(8) if user.type == 'Host'
      user.save!
    end
  end

  #
  # Creates +n+ feedbacks
  #
  def create_feedbacks(n)
    n.times do
      sender, recipient = loop do
        from, to = User.limit(2).order('RANDOM()')
        break [from, to] unless Feedback.exists?(sender: from, recipient: to)
      end

      feedback = Feedback.new content: FFaker::Lorem.sentence(5),
                              score: rand_score,
                              sender: sender,
                              recipient: recipient
      feedback.recipient.karma += feedback.score.value
      feedback.recipient.save!
      feedback.save!
    end
  end

  #
  # Creates +n+ language skills
  #
  def create_language_skills(n)
    n.times do
      lang, user = loop do
        l = Language.limit(1).order('RANDOM()').first
        u = User.limit(1).order('RANDOM()').first
        break [l, u] unless LanguageSkill.exists?(language: l, user: u)
      end

      language_skill =
        LanguageSkill.new language: lang, user: user,
                          level: LanguageSkill.level.values[rand(5)]
      language_skill.save!
    end
  end

  desc 'Fill database with sample data'
  task populate: :environment do
    fail("Don't do this in production") if Rails.env.production?

    User.destroy_all
    create_users(50)

    Feedback.destroy_all
    create_feedbacks(250)

    LanguageSkill.destroy_all
    create_language_skills(100)
  end
end
