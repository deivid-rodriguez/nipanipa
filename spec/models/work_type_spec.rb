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
  let(:work_type) { WorkType.new(name:'Farming',
                                 description:'Countryside jobs in rural areas')
  }

  subject { work_type }

  it { should respond_to(:name) }
  it { should respond_to(:description) }

  describe "when name is not present" do
    before { work_type.name = '' }
    it { should_not be_valid }
  end
end
