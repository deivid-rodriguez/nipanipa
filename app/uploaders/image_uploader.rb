# frozen_string_literal: true

#
# Image Uploader required by CarrierWave
#
class ImageUploader < CarrierWave::Uploader::Base
  # Internal image processor
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb, from_version: :thumb_message do
    process resize_to_fill: [40, 40]
  end

  version :thumb_message, from_version: :small do
    process resize_to_fill: [69, 69]
  end

  version :small, from_version: :medium do
    process resize_to_fill: [145, 103]
  end

  version :medium, from_version: :large do
    process resize_to_fill: [220, 220]
  end

  version :large do
    process resize_to_fill: [450, 240]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for
  # details.
  #
  # def filename
  #   "something.jpg" if original_filename
  # end
end
