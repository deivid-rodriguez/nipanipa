# == Schema Information
#
# Table name: donations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  amount     :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Donation do
  it "should be valid" do
    Donation.new.should be_valid
  end
end
