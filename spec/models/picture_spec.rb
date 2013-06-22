require 'spec_helper'

describe Picture do
  let(:profile_picture) { build(:picture) }

  subject { profile_picture }

  it { should respond_to(:name) }
  it { should respond_to(:image) }
  it { should respond_to(:user_id) }
  it { should respond_to(:avatar) }

  it { should be_valid }
end
