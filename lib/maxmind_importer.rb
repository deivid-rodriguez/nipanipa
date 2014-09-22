require 'zip'
require 'progress_bar'

module MaxmindImporter
  extend self

  def already_imported?
    remote_zip_file_checksum == zip_file_checksum
  end

  def download!
    open(local_zip_path, 'wb') do |file|
      uri = URI.parse(remote_zip_url)
      Net::HTTP.start(uri.host, uri.port) do |http|
        http.request_get(uri.path) do |resp|
          resp.read_body { |segment| file.write(segment) }
        end
      end
    end
  end

  def extract!
    Zip::File.open(local_zip_path).
              glob("*/#{csv_file_name}").
              first.
              extract(local_csv_path)
  end

  def insert!
    bar = ProgressBar.new(%x{ wc -l #{local_csv_path} }.split[0].to_i)

    CSV.foreach(local_csv_path, headers: :first_row) do |l|
      next unless l[1].present? && l[3].present? && l[5].present?

      country = Country.find_by_code_and_continent_code(l[3], l[1])
      next unless country

      country.regions.find_or_create_by!(code: l[5]) { |reg| reg.name = l[6] }

      bar.increment!
    end

  rescue => e
    File.delete(local_zip_path)
    raise e
  ensure
    File.delete(local_csv_path)
  end

  private

  def remote_base_url
    'http://geolite.maxmind.com/download/geoip/database/'
  end

  def zip_file_name
    'GeoLite2-City-CSV.zip'
  end

  def remote_zip_url
    remote_base_url + zip_file_name
  end

  def checksum_file_name
    zip_file_name + '.md5'
  end

  def remote_checksum_url
    remote_base_url + checksum_file_name
  end

  def zip_file_checksum
    return '' unless File.exist?(local_zip_path)

    Digest::MD5.file(local_zip_path).hexdigest
  end

  def remote_zip_file_checksum
    open(remote_checksum_url).read
  end

  def csv_file_name
    'GeoLite2-City-Locations.csv'
  end

  def local_base_path
    'tmp/'
  end

  def local_zip_path
    local_base_path + zip_file_name
  end

  def local_csv_path
    local_base_path + csv_file_name
  end
end
