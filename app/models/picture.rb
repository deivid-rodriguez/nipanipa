#
# Picture Model, through carrierwave
#
class Picture < ActiveRecord::Base
  belongs_to :user

  scope :random, ->(num) { limit(num).order('RANDOM()') }

  mount_uploader :image, ImageUploader
end
