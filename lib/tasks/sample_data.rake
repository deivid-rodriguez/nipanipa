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
      now = Time.zone.now

      type.classify.constantize.create! \
        name: FFaker::Name.name,
        email: "#{type}#{i}@example.com",
        password: '111111',
        password_confirmation: '111111',
        description: FFaker::Lorem.paragraph(10),
        region: Region.limit(1).order('RANDOM()').first,
        last_sign_in_at: now,
        current_sign_in_at: now,
        sign_in_count: 1,
        confirmed_at: now,
        work_types: WorkType.limit(rand(3)).order('RANDOM()'),
        skills: FFaker::Lorem.paragraph(11),
        accomodation: type == 'host' ? FFaker::Lorem.paragraph(8) : nil
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

  #
  # Creates +n+ messages between users
  #
  def create_messages(n)
    n.times do
      from, to = User.limit(2).order('RANDOM()')
      body = FFaker::Lorem.paragraph(rand(2))

      Message.create(sender: from, recipient: to, body: body)
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

    Message.destroy_all
    create_messages(300)
  end
end
