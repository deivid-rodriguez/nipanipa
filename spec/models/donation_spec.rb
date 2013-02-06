require 'spec_helper'

describe Donation do
  it "should be valid" do
    Donation.new.should be_valid
  end
end
