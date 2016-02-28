# frozen_string_literal: true

#
# Unit tests for Country model
#
RSpec.describe Country do
  let!(:country) { build(:country, code: "DE") }

  it "has a code" do
    country.code = nil

    expect(country).not_to be_valid
  end

  it "has a unique code" do
    create(:country, code: country.code)

    expect(country).not_to be_valid
  end

  it "has a continent" do
    country.continent = nil

    expect(country).not_to be_valid
  end

  it ".with_users" do
    country.save!

    user = create(:user, country: country)
    expect(Country.with_users).to include(country)

    region = create(:region, country: create(:country, code: "IT"))
    user.update_attribute(:region, region)
    expect(Country.with_users).not_to include(country)
  end
end
