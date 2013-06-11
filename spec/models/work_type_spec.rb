#
# Unit tests for WorkType model
#

describe WorkType do
  let!(:work_type) { build(:work_type, name: 'gardening') }

  subject { work_type }

  it { should respond_to(:name) }
  it { should respond_to(:description) }

  it { should be_valid }

  describe 'attributes not accessible' do
    it 'should raise an error when trying to mass-assign attributes' do
      expect do
        WorkType.new name: 'Other', description: 'Any other activity'
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
end
