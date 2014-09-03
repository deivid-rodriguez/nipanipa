#
# Unit tests for LanguageSkill model
#
RSpec.describe LanguageSkill do
  it 'has a valid factory' do
    expect(create(:language_skill)).to be_valid
  end

  it 'has a valid soft factory' do
    expect(build(:language_skill)).to be_valid
  end

  it 'has a level' do
    expect(build(:language_skill, level: nil)).not_to be_valid
  end
end
