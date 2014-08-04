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

  it { is_expected.to validate_presence_of(:level) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:language) }
end
