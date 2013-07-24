class Picture < ActiveRecord::Base
  attr_accessible :image, :image_cache, :name, :user_id

  belongs_to :user

  mount_uploader :image, ImageUploader
end
