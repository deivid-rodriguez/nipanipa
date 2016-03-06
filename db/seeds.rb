# frozen_string_literal: true

#
# Default job sectors
#
WorkType.create [{ name: "gardening" },
                 { name: "babysitting" },
                 { name: "cooking" },
                 { name: "farming" },
                 { name: "housekeeping" },
                 { name: "tourism" },
                 { name: "language_exchange" },
                 { name: "teaching" },
                 { name: "construction" },
                 { name: "elderly_care" },
                 { name: "animal_care" },
                 { name: "humanitarian_aid" },
                 { name: "technical_assistance" },
                 { name: "art_project" },
                 { name: "wwoofing" }]

#
# Default languages
#
Language.create [{ code: "af" },
                 { code: "ar" },
                 { code: "bg" },
                 { code: "bn" },
                 { code: "bo" },
                 { code: "ca" },
                 { code: "cs" },
                 { code: "cy" },
                 { code: "da" },
                 { code: "de" },
                 { code: "el" },
                 { code: "en" },
                 { code: "es" },
                 { code: "et" },
                 { code: "eu" },
                 { code: "fa" },
                 { code: "fi" },
                 { code: "fj" },
                 { code: "fr" },
                 { code: "ga" },
                 { code: "gu" },
                 { code: "he" },
                 { code: "hi" },
                 { code: "hr" },
                 { code: "hu" },
                 { code: "hy" },
                 { code: "id" },
                 { code: "is" },
                 { code: "it" },
                 { code: "ja" },
                 { code: "jw" },
                 { code: "ka" },
                 { code: "km" },
                 { code: "ko" },
                 { code: "la" },
                 { code: "lt" },
                 { code: "lv" },
                 { code: "mi" },
                 { code: "mk" },
                 { code: "ml" },
                 { code: "mn" },
                 { code: "mr" },
                 { code: "ms" },
                 { code: "mt" },
                 { code: "ne" },
                 { code: "nl" },
                 { code: "no" },
                 { code: "pa" },
                 { code: "pl" },
                 { code: "pt" },
                 { code: "qu" },
                 { code: "ro" },
                 { code: "ru" },
                 { code: "sk" },
                 { code: "sl" },
                 { code: "sm" },
                 { code: "sq" },
                 { code: "sr" },
                 { code: "sv" },
                 { code: "sw" },
                 { code: "ta" },
                 { code: "te" },
                 { code: "th" },
                 { code: "to" },
                 { code: "tr" },
                 { code: "tt" },
                 { code: "uk" },
                 { code: "ur" },
                 { code: "uz" },
                 { code: "vi" },
                 { code: "xh" },
                 { code: "zh" }]

#
# Countries
#
Rake::Task["db:maxmind:countries"].invoke

#
# Regions
#
Rake::Task["db:maxmind:regions"].invoke
