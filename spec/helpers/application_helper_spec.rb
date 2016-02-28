# frozen_string_literal: true

#
# Unit tests for ApplicationHelper
#
RSpec.describe ApplicationHelper do
  describe "full_title" do
    it "should include the page title" do
      expect(full_title("foo")).to match(/foo/)
    end
    it "should include the base title" do
      expect(full_title("foo")).to match(/^NiPaNiPa/)
    end
    it "should not include the base title" do
      expect(full_title("")).not_to match(/\|/)
    end
  end
end
