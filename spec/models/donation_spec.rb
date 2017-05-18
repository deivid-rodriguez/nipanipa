# frozen_string_literal: true

#
# Unit tests for Donation model
#
RSpec.describe Donation do
  it "is valid" do
    expect(build(:donation)).to be_valid
  end

  it "doesn't allow non-positive amounts" do
    expect(build(:donation, amount: 0)).to_not be_valid
    expect(build(:donation, amount: -10.0)).to_not be_valid
  end
end
