#
# Tasks for loading geographical data into our database
#
namespace :db do
  def load_countries
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
    return if MaxmindImporter.already_imported?

    puts 'Downloading region information from MaxMind...'
    MaxmindImporter.download!

    puts 'Extracting information to disk...'
    MaxmindImporter.extract!

    puts 'Loading regions into database'
    MaxmindImporter.insert!
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
