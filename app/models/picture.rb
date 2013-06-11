class Picture < ActiveRecord::Base
  attr_accessible :picture_content_type, :picture_file_name, :picture_file_size,
                  :picture_updated_at, :picture, :user_id, :avatar

  belongs_to :user

  has_attached_file :picture, styles: lambda { |attachment|
    if attachment.instance.avatar
      { thumb: '100x100#', medium: '200x200#' }
    else
      { thumb: '100x100>', medium: '200x200>' }
    end }

  validates_attachment :picture, size: { in: 0..250.kilobyte }
end
