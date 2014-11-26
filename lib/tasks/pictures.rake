#
# Tasks for picture processing
#
namespace :pictures do
  desc 'Regenerates styles and removes broken pics'
  task update_and_repair: :environment do
    Picture.find_each do |picture|
      picture.image? ? picture.image.recreate_versions! : picture.destroy!
    end
  end
end
