require 'support/i18n'

describe 'i18n files' do
  extend I18nHelpers

  load_locales

  locales_to_keys.each do |locale, keys|
    unique_keys.each do |key|
      it "should translate #{key} in locale :#{locale}" do
        keys.include?(key).should be_true,
          "Expected #{key} to be among the #{locale} locale's translation " \
          "keys, but it wasn't"
      end
    end
  end
end
