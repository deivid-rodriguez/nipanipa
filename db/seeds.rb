# frozen_string_literal: true

#
# Default job sectors
#
WorkType.create [{ name: 'gardening' },
                 { name: 'babysitting' },
                 { name: 'cooking' },
                 { name: 'farming' },
                 { name: 'housekeeping' },
                 { name: 'tourism' },
                 { name: 'language_exchange' },
                 { name: 'teaching' },
                 { name: 'construction' },
                 { name: 'elderly_care' },
                 { name: 'animal_care' },
                 { name: 'humanitarian_aid' },
                 { name: 'technical_assistance' },
                 { name: 'art_project' },
                 { name: 'wwoofing' }]

#
# Default languages
#
Language.create [{ code: 'af', name: 'Afrikaans' },
                 { code: 'ar', name: 'Arabic' },
                 { code: 'bg', name: 'Bulgarian' },
                 { code: 'bn', name: 'Bengali' },
                 { code: 'bo', name: 'Tibetan' },
                 { code: 'ca', name: 'Catalan' },
                 { code: 'cs', name: 'Czech' },
                 { code: 'cy', name: 'Welsh' },
                 { code: 'da', name: 'Danish' },
                 { code: 'de', name: 'German' },
                 { code: 'el', name: 'Greek' },
                 { code: 'en', name: 'English' },
                 { code: 'es', name: 'Spanish' },
                 { code: 'et', name: 'Estonian' },
                 { code: 'eu', name: 'Basque' },
                 { code: 'fa', name: 'Persian' },
                 { code: 'fi', name: 'Finnish' },
                 { code: 'fj', name: 'Fiji' },
                 { code: 'fr', name: 'French' },
                 { code: 'ga', name: 'Irish' },
                 { code: 'gu', name: 'Gujarati' },
                 { code: 'he', name: 'Hebrew' },
                 { code: 'hi', name: 'Hindi' },
                 { code: 'hr', name: 'Croatian' },
                 { code: 'hu', name: 'Hungarian' },
                 { code: 'hy', name: 'Armenian' },
                 { code: 'id', name: 'Indonesian' },
                 { code: 'is', name: 'Icelandic' },
                 { code: 'it', name: 'Italian' },
                 { code: 'ja', name: 'Japanese' },
                 { code: 'jw', name: 'Javanese' },
                 { code: 'ka', name: 'Georgian' },
                 { code: 'km', name: 'Cambodian' },
                 { code: 'ko', name: 'Korean' },
                 { code: 'la', name: 'Latin' },
                 { code: 'lt', name: 'Lithuanian' },
                 { code: 'lv', name: 'Latvian' },
                 { code: 'mi', name: 'Maori' },
                 { code: 'mk', name: 'Macedonian' },
                 { code: 'ml', name: 'Malayalam' },
                 { code: 'mn', name: 'Mongolian' },
                 { code: 'mr', name: 'Marathi' },
                 { code: 'ms', name: 'Malay' },
                 { code: 'mt', name: 'Maltese' },
                 { code: 'ne', name: 'Nepali' },
                 { code: 'nl', name: 'Dutch' },
                 { code: 'no', name: 'Norwegian' },
                 { code: 'pa', name: 'Punjabi' },
                 { code: 'pl', name: 'Polish' },
                 { code: 'pt', name: 'Portuguese' },
                 { code: 'qu', name: 'Quechua' },
                 { code: 'ro', name: 'Romanian' },
                 { code: 'ru', name: 'Russian' },
                 { code: 'sk', name: 'Slovak' },
                 { code: 'sl', name: 'Slovenian' },
                 { code: 'sm', name: 'Samoan' },
                 { code: 'sq', name: 'Albanian' },
                 { code: 'sr', name: 'Serbian' },
                 { code: 'sv', name: 'Swedish' },
                 { code: 'sw', name: 'Swahili' },
                 { code: 'ta', name: 'Tamil' },
                 { code: 'te', name: 'Telugu' },
                 { code: 'th', name: 'Thai' },
                 { code: 'to', name: 'Tonga' },
                 { code: 'tr', name: 'Turkish' },
                 { code: 'tt', name: 'Tatar' },
                 { code: 'uk', name: 'Ukrainian' },
                 { code: 'ur', name: 'Urdu' },
                 { code: 'uz', name: 'Uzbek' },
                 { code: 'vi', name: 'Vietnamese' },
                 { code: 'xh', name: 'Xhosa' },
                 { code: 'zh', name: 'Chinese' }]

#
# Countries
#
Rake::Task['db:maxmind:countries'].invoke

#
# Regions
#
Rake::Task['db:maxmind:regions'].invoke
