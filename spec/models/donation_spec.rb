#
# Unit tests for Donation model
#

describe Donation do
  it "should be valid" do
    Donation.new.should be_valid
  end
end
