require 'spec_helper'

describe Picture do
  let(:profile_picture) { build(:picture) }

  subject { profile_picture }

  it { should respond_to(:picture_file_name) }
  it { should respond_to(:picture_file_size) }
  it { should respond_to(:picture_content_type) }
  it { should respond_to(:picture_updated_at) }
  it { should respond_to(:picture) }
  it { should respond_to(:user_id) }
  it { should respond_to(:avatar) }

  it { should be_valid }

  describe "styles" do
    let(:style_lambda) { Picture.attachment_definitions[:picture][:styles] }

    context "when avatar" do
      before { profile_picture.avatar = true }

      it "crops" do
        style_lambda.call(profile_picture.picture)[:thumb].should == "100x100#"
        style_lambda.call(profile_picture.picture)[:medium].should == "200x200#"
      end
    end

    context "when non avatar" do
      before { profile_picture.avatar = false }

      it "keeps proportions" do
        style_lambda.call(profile_picture.picture)[:thumb].should == "100x100>"
        style_lambda.call(profile_picture.picture)[:medium].should == "200x200>"
      end
    end
  end

  describe "too big" do
    before { profile_picture.picture_file_size = 251.kilobyte }

    it { should_not be_valid }
  end
end
