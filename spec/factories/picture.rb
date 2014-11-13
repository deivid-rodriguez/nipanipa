FactoryGirl.define do
  factory :picture do
    name 'My funny picture'
    image do
      Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/test_img.png")
    end
    association :user, factory: :host
  end
end
