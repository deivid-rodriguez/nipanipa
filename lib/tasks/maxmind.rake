#
# Tasks for loading geographical data into our database
#
namespace :db do
  def load_countries
    puts 'Loading country information from our YAML files...'

    data = YAML.load(File.read("#{Rails.root}/config/locales/en/geo.yml"))
    data['en']['continents'].each do |continent_code, _|
      con_iso = continent_code.upcase
      continent = Continent.find_or_create_by!(code: con_iso)

      data['en']['countries'][continent_code].each do |country_code, _|
        cou_iso = country_code.upcase
        Country.find_or_create_by!(code: cou_iso, continent_id: continent.id)
      end
    end
  end

  def load_regions
    require 'maxmind_importer'
    importer = Maxmind::Importer.new

    puts 'Downloading region information from MaxMind...'
    importer.download!

    puts 'Extracting information to disk...'
    importer.extract!

    puts 'Loading regions into database'
    importer.insert!
  end

  namespace :maxmind do
    desc 'Load country (and continent) info into db'
    task countries: :environment do
      load_countries
    end

    desc 'Load regions into db'
    task regions: :environment do
      load_regions
    end
  end
end
