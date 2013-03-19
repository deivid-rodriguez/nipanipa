# == Schema Information
#
# Table name: offers
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  description   :text
#  accomodation  :text
#  vacancies     :integer
#  start_date    :date
#  end_date      :date
#  min_stay      :integer
#  hours_per_day :integer
#  days_per_week :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  host_id       :integer
#

describe Offer do

  it "has a valid factory" do
    create(:offer).should be_valid
  end

  it "is invalid without a title" do
    build(:offer, title: nil).should_not be_valid
    build(:offer, title: '').should_not be_valid
  end

  it "is invalid without a description" do
    build(:offer, description: nil).should_not be_valid
    build(:offer, description: '').should_not be_valid
  end

  it "is invalid without accomodation" do
    build(:offer, accomodation: nil).should_not be_valid
    build(:offer, accomodation: '').should_not be_valid
  end

  it "is invalid without vacancies" do
    build(:offer, vacancies: nil).should_not be_valid
  end

  describe "#available?" do
    specify { build(:offer, :open).available?.should be_true }
    specify { build(:offer, :active).available?.should be_true }
    specify { build(:offer, :inactive).available?.should_not be_true }
    specify { build(:offer, :expired).available?.should_not be_true }

  end

end
