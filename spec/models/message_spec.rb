#
# Unit tests for Message model
#

describe Message do

  it "has a valid factory" do
    create(:conversation).should be_valid
  end

  it { should belong_to(:conversation) }

  it { should belong_to(:from).class_name('User') }
  it { should belong_to(:to).class_name('User') }
end
