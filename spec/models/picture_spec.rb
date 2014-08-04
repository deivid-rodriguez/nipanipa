#
# Unit tests for Picture model
#

RSpec.describe Picture do
  let(:picture) { build(:picture) }

  subject { picture }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:image) }
  it { is_expected.to respond_to(:user_id) }

  it { is_expected.to be_valid }
end
