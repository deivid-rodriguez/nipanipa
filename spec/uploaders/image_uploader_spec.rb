require 'carrierwave/test/matchers'

describe ImageUploader do
  include CarrierWave::Test::Matchers

  let!(:user) { build(:user) }

  before do
    ImageUploader.enable_processing = true
    @uploader = ImageUploader.new(user, :image)
    @uploader.store!(File.open("#{Rails.root}/app/assets/images/default_avatar_medium.png"))
  end

  after do
    ImageUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the thumb version' do
    it "should scale down a landscape image to be exactly 40x40" do
      @uploader.thumb.should have_dimensions(40, 40)
    end
  end

  context 'the small version' do
    it "should scale down a landscape image to fit within 100x100" do
      @uploader.small.should be_no_larger_than(100, 100)
    end
  end

  context 'the medium version' do
    it "should scale down a landscape image to be exactly 260x260" do
      @uploader.small.should have_dimensions(100, 100)
    end
  end

  context 'the small version' do
    it "should scale down a landscape image to fit within 350x350" do
      @uploader.small.should be_no_larger_than(350, 350)
    end
  end
end
