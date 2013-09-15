#
# Unit tests for WorkType model
#

describe WorkType do
  let!(:work_type) { build(:work_type, name: 'gardening') }

  subject { work_type }

  it { should respond_to(:name) }
  it { should respond_to(:description) }

  it { should be_valid }
end
