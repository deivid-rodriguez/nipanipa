#
# Unit tests for Message model
#

RSpec.describe Message do

  it 'has a valid factory' do
    expect(create(:conversation)).to be_valid
  end

  it { is_expected.to belong_to(:conversation) }

  it { is_expected.to belong_to(:from).class_name('User') }
  it { is_expected.to belong_to(:to).class_name('User') }
end
