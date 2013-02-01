# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create default job sectors
WorkType.create(name: 'gardening')
WorkType.create(name: 'babysitting')
WorkType.create(name: 'cooking')
WorkType.create(name: 'farming')
WorkType.create(name: 'housekeeping')
WorkType.create(name: 'tourism')
WorkType.create(name: 'language_exchange')
WorkType.create(name: 'teaching')
WorkType.create(name: 'construction')
WorkType.create(name: 'elderly_care')
WorkType.create(name: 'animal_care')
WorkType.create(name: 'humanitarian_aid')
WorkType.create(name: 'technical_assistance')
WorkType.create(name: 'art_project')
WorkType.create(name: 'other')
