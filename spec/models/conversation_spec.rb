#
# Unit tests for Conversation model
#

describe Conversation do
  it "should be valid" do
    Conversation.new.should be_valid
  end
end
