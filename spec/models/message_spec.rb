#
# Unit tests for Message model
#
RSpec.describe Message do
  it 'has a valid factory' do
    expect(create(:conversation)).to be_valid
  end
end
