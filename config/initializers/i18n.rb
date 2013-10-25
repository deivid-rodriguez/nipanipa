#encoding: utf-8
I18n.available_locales = [:de, :en, :es, :it]

LANGUAGES = [
              ['Deutsch',                  'de'],
              ['English',                  'en'],
              ["Espa&ntilde;ol".html_safe, 'es'],
              ['Italiano',                 'it']
            ]

# A simple exception handler that behaves like the default exception handler
# but additionally logs missing translations to a given log.
module I18n
  class << self
    def missing_translations_logger
      @@missing_translations_logger ||=
         Logger.new(Rails.root.join('log', 'missing_translations.log'))
    end

    def missing_translations_log_handler(exception, locale, key, options)
      if MissingTranslation === exception
        missing_translations_logger.
          warn( [Time.now, exception.message].join(": ") )
        return exception.message
      else
        raise exception
      end
    end
  end
end
I18n.exception_handler = :missing_translations_log_handler
