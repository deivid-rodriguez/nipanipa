require 'carrierwave/test/matchers'

RSpec.describe ImageUploader do
  include CarrierWave::Test::Matchers

  let!(:user) { build(:user) }

  before do
    ImageUploader.enable_processing = true
    @uploader = ImageUploader.new(user, :image)
    @uploader.store!(
      File.open("#{Rails.root}/app/assets/images/host1_small_cropped.png"))
  end

  after do
    ImageUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the thumb version' do
    it "should scale down a landscape image to be exactly 40x40" do
      expect(@uploader.thumb).to have_dimensions(40, 40)
    end
  end

  context 'the small version' do
    it "should scale down a landscape image to fit within 140x140" do
      expect(@uploader.small).to be_no_larger_than(140, 140)
    end
  end

  context 'the small cropped version' do
    it "should scale down a landscape image to be exactly 140x140" do
      expect(@uploader.small_cropped).to have_dimensions(140, 140)
    end
  end

  context 'the medium version' do
    it "should scale down a landscape image to be exactly 220x220" do
      expect(@uploader.medium).to have_dimensions(220, 220)
    end
  end

  context 'the large version' do
    it "should scale down a landscape image to fit within 350x350" do
      expect(@uploader.large).to be_no_larger_than(350, 350)
    end
  end
end
