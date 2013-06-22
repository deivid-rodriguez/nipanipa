class Picture < ActiveRecord::Base
  attr_accessible :avatar, :image, :image_cache, :name, :user_id

  before_save :clear_avatars, if: :avatar

  belongs_to :user

  mount_uploader :image, ImageUploader

  private

    def clear_avatars
      Picture.where(user_id: self.user_id).update_all(avatar: false)
    end
end
