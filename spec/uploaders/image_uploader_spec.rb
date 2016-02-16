# frozen_string_literal: true

require 'carrierwave/test/matchers'

RSpec.describe ImageUploader do
  include CarrierWave::Test::Matchers

  let!(:user) { build(:user) }
  let!(:img) { File.open("#{Rails.root}/app/assets/images/host1_small.png") }

  before do
    ImageUploader.enable_processing = true
    @uploader = ImageUploader.new(user, :image)
    @uploader.store!(img)
  end

  after do
    ImageUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the thumb version' do
    it 'should scale down a landscape image to be exactly 40x40' do
      expect(@uploader.thumb).to have_dimensions(40, 40)
    end
  end

  context 'the small version' do
    it 'should scale down a landscape image to be exactly 146x103' do
      expect(@uploader.small).to have_dimensions(145, 103)
    end
  end

  context 'the medium version' do
    it 'should scale down a landscape image to be exactly 220x220' do
      expect(@uploader.medium).to have_dimensions(220, 220)
    end
  end

  context 'the large version' do
    it 'should scale down a landscape image to fit within 350x350' do
      expect(@uploader.large).to have_dimensions(450, 240)
    end
  end
end
