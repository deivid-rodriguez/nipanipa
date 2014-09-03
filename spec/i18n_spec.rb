require 'support/i18n'

RSpec.describe 'i18n files' do
  extend I18nHelpers

  load_locales

  locales_to_keys.each do |locale, keys|
    unique_keys.each do |key|
      it "should translate #{key} in locale :#{locale}" do
        err = "Expected #{key} to be among the #{locale} locale's " \
              "translation keys, but it wasn't"
        expect(keys.include?(key)).to(be_truthy, err)
      end
    end
  end
end
