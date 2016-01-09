require 'zip'
require 'csv'
require 'ruby-progressbar'

#
# Imports geographical Database information from MaxMind
#
module Maxmind
  #
  # Extensions for our Country model
  #
  module CountryExtensions
    def find_by_code_and_continent_code(geo)
      return unless geo.country_code.present? && geo.continent_code.present?

      scope = where(code: geo.country_code,
                    continents: { code: geo.continent_code })

      fail('Inconsistent Database') if scope.size > 1

      scope.first
    end
  end

  Country.extend CountryExtensions

  #
  # Utitities for our Country instances
  #
  module CountryUtils
    def insert_region!(geo)
      return unless geo.region_code.present?

      regions.find_or_create_by!(code: geo.region_code) do |region|
        region.name = geo.region_name
      end
    end
  end

  Country.include CountryUtils

  #
  # Adapts Maxmind's CSV structure to our needs.
  #
  class Adapter
    attr_accessor :data

    def initialize(data)
      @data = data
    end

    def continent_code
      data[2]
    end

    def country_code
      data[4]
    end

    def region_code
      data[6]
    end

    def region_name
      data[7]
    end
  end

  #
  # Imports geographical Database information from MaxMind
  #
  class Importer
    #
    # Accepts an option to indicate whether the importer should cleanup
    # temporary files after import or not
    #
    def initialize(cleanup = false)
      @cleanup = cleanup
    end

    #
    # Downloads zip file from Maxmind
    #
    def download!
      return if remote_zip_file_unchanged?

      open(local_zip_path, 'wb') do |file|
        uri = URI.parse(remote_zip_url)
        Net::HTTP.start(uri.host, uri.port) do |http|
          http.request_get(uri.path) do |resp|
            resp.read_body { |segment| file.write(segment) }
          end
        end
      end

      download_succeeded?
    end

    #
    # Extracts CSV file from downloaded file
    #
    def extract!
      Zip.on_exists_proc = true

      Zip::File.open(local_zip_path)
               .glob("*/#{csv_file_name}")
               .first
               .extract(local_csv_path)

      extract_succeeded?
    end

    #
    # Parses CSV file and inserts information in DB
    #
    def insert!
      bar = ProgressBar.create(total: csv_n_lines)

      CSV.foreach(local_csv_path, headers: :first_row) do |line|
        geo_info = Adapter.new(line)

        insert_one!(geo_info)

        bar.increment
      end

      true
    end

    #
    # Cleans up generated files
    #
    def cleanup
      File.delete(local_zip_path)
      File.delete(local_csv_path)
    end

    #
    # Imports Maxmind geographical information into our DB
    #
    def import!
      download! && extract! && insert!
    ensure
      cleanup if @cleanup
    end

    private

    def csv_n_lines
      ` wc -l #{local_csv_path} `.split[0].to_i
    end

    def download_succeeded?
      remote_zip_file_checksum == zip_file_checksum
    end
    alias remote_zip_file_unchanged? download_succeeded?

    def extract_succeeded?
      !File.zero?(local_csv_path)
    end

    def insert_one!(data)
      country = Country.find_by_code_and_continent_code(data)
      return unless country

      country.insert_region!(data)
    end

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
      'GeoLite2-City-Locations-en.csv'
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
end
