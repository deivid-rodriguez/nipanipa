require 'spec_helper'

describe Location do

  describe "creation" do
    let(:location) { Location.new }

    subject { location }

    it { should respond_to(:address) }
    it { should respond_to(:longitude) }
    it { should respond_to(:latitude) }

    it { should be_valid }

    describe "should not permit duplicate cities" do
      let(:location_dup) { Location.new(address: location.address) }

      before { location.save }

      subject { location_dup }

      it { should_not be_valid }
    end

  end

end
