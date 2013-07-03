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
    it "should scale down a landscape image to fit within 140x140" do
      @uploader.small.should be_no_larger_than(140, 140)
    end
  end

  context 'the small cropped version' do
    it "should scale down a landscape image to be exactly 140x140" do
      @uploader.small_cropped.should have_dimensions(140, 140)
    end
  end

  context 'the medium version' do
    it "should scale down a landscape image to be exactly 265x265" do
      @uploader.medium.should have_dimensions(265, 265)
    end
  end

  context 'the large version' do
    it "should scale down a landscape image to fit within 350x350" do
      @uploader.large.should be_no_larger_than(350, 350)
    end
  end
end
