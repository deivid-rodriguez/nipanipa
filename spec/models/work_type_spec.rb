# == Schema Information
#
# Table name: work_types
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#

require 'spec_helper'

describe WorkType do
  let(:work_type) { WorkType.new }

  subject { work_type }

  it { should_not be_valid }

  it { should respond_to(:name) }
  it { should respond_to(:description) }

  describe "attributes not accessible" do
    before do
      work_type.name = 'Farming'
      work_type.description = 'Countryside jobs in rural areas'
    end

    it "should raise an error when trying to mass-assign attributes" do
      expect do
        WorkType.new name: 'Other', description: 'Any other activity'
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

end
