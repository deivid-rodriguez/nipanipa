# == Schema Information
#
# Table name: sectorizations
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  work_type_id :integer
#

require 'spec_helper'

describe Sectorization do

  let(:user) { FactoryGirl.create(:user) }
  let(:work_type) {
    WorkType.create(name:'Languages',
                    description: 'Teaching your tongue language') }
  let(:sectorization) { user.sectorizations.build(work_type_id: work_type.id) }

  subject { sectorization }

  it { should be_valid }


  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect { Sectorization.new( user_id: user.id )
      }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when user_id is not present" do
    before { sectorization.user_id = '' }
    it { should_not be_valid }
  end

  describe "when work_type_id is not present" do
    before { sectorization.work_type_id = '' }
    it { should_not be_valid }
  end

end
