require 'spec_helper'

describe Location do

  describe "creation" do
    let(:location) { build(:location) }

    subject { location }

    it { should respond_to(:address) }
    it { should respond_to(:longitude) }
    it { should respond_to(:latitude) }

    it { should be_valid }

    describe "should not permit duplicate cities cities" do
      let(:location_dup) { build(:location, address: location.address) }

      before { location.save }

      subject { location_dup }

      it { should_not be_valid }
    end

  end

end
