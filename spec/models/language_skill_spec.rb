# frozen_string_literal: true

#
# Unit tests for LanguageSkill model
#
RSpec.describe LanguageSkill do
  let(:language_skill) { build(:language_skill) }

  it "has a level" do
    language_skill.level = nil

    expect(language_skill).not_to be_valid
  end

  it "has a user" do
    language_skill.user = nil

    expect(language_skill).not_to be_valid
  end

  it "has a language" do
    language_skill.language = nil

    expect(language_skill).not_to be_valid
  end

  it "is unique per user and language" do
    language_skill.save!
    dupped_attrs = language_skill.attributes.slice("user_id", "language_id")

    expect(build(:language_skill, dupped_attrs)).not_to be_valid
  end
end
