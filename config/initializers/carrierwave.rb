unless Rails.env.production?
  CarrierWave.configure do |config|
    config.ignore_integrity_errors = false
    config.ignore_processing_errors = false
    config.ignore_download_errors = false

    if Rails.env.test?
      config.storage = :file
      config.enable_processing = false
    end
  end
end
