unless Rails.env.production?
  require 'ffaker'

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
    # Create the n-th user
    #
    def create_user(n)
      type = %w(host volunteer).sample
      now = Time.zone.now

      type.classify.constantize.create! \
        name: FFaker::Name.name,
        email: "#{type}#{n}@example.com",
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
        accomodation: type == 'host' ? FFaker::Lorem.paragraph(8) : nil,
        availability: (1..12).to_a.sample(rand(12) + 1)
    end

    #
    # Creates a new feedback
    #
    def create_feedback
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

    #
    # Creates a new language skill
    #
    def create_language_skill
      lang, user = loop do
        l = Language.limit(1).order('RANDOM()').first
        u = User.limit(1).order('RANDOM()').first
        break [l, u] unless LanguageSkill.exists?(language: l, user: u)
      end

      LanguageSkill.create! language: lang,
                            user: user,
                            level: LanguageSkill.level.values[rand(5)]
    end

    #
    # Creates a new message
    #
    def create_message
      from, to = User.limit(2).order('RANDOM()')
      body = FFaker::Lorem.paragraph(rand(2) + 1)

      Message.create!(sender: from, recipient: to, body: body)
    end

    def create_admin_user
      AdminUser.create!(email: 'admin@example.com', password: '111111')
    end

    def admin_users
      AdminUser.destroy_all

      create_admin_user
    end

    def users
      User.destroy_all

      50.times { |n| create_user(n) }
    end

    def feedbacks
      Feedback.destroy_all

      250.times { create_feedback }
    end

    def language_skills
      LanguageSkill.destroy_all

      100.times { create_language_skill }
    end

    def messages
      Message.destroy_all

      300.times { create_message }
    end

    desc 'Fill database with sample data'
    task populate: :environment do
      fail("Don't do this in production") if Rails.env.production?

      admin_users
      users
      feedbacks
      language_skills
      messages
    end
  end
end
