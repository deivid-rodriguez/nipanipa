# frozen_string_literal: true

#
# Picture Model, through carrierwave
#
class Picture < ApplicationRecord
  belongs_to :user

  scope :random, ->(num) { limit(num).order("RANDOM()") }

  mount_uploader :image, ImageUploader
end
