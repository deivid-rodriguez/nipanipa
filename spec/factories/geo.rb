FactoryGirl.define do
  sequence(:random_code_2) do |n|
    code = (n % 26 + 65).chr
    remainder = n / 26

    code + (remainder % 26 + 65).chr
  end

  factory :region do
    transient { continent nil }

    code { generate(:random_code_2) }

    country do
      if continent
        FactoryGirl.create(:country, continent: continent)
      else
        FactoryGirl.create(:country)
      end
    end
  end

  factory :country do
    code { generate(:random_code_2) }

    continent
  end

  factory :continent do
    code { generate(:random_code_2) }
  end
end
