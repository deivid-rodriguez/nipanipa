#
# Unit tests for Donation model
#

RSpec.describe Donation do
  it "should be valid" do
    expect(Donation.new).to be_valid
  end
end
