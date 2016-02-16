# frozen_string_literal: true

#
# Unit tests for WorkType model
#
RSpec.describe WorkType do
  let!(:work_type) { build(:work_type, name: 'gardening') }

  subject { work_type }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:description) }

  it { is_expected.to be_valid }
end
