#
# Unit tests for LanguageSkill model
#

describe LanguageSkill do
  it 'has a valid factory' do
    create(:language_skill).should be_valid
  end

  it 'has a valid soft factory' do
    build(:language_skill).should be_valid
  end

  it { should validate_presence_of(:level) }

  it { should belong_to(:user) }
  it { should belong_to(:language) }
end
