# == Schema Information
#
# Table name: sectorizations
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  work_type_id :integer
#

#describe Sectorization do
#
#  let(:user) { create(:user) }
#  let(:work_type) {
#    WorkType.create(name:'Languages',
#                    description: 'Teaching your tongue language') }
#  let(:sectorization) { user.sectorizations.build(work_type_id: work_type.id) }
#
#  subject { sectorization }
#
#  it { should be_valid }
#
## describe "when work_type_id is not present" do
##   before { sectorization.work_type_id = '' }
##   it { should_not be_valid }
## end
#
#end
