# frozen_string_literal: true

source "https://rubygems.org"

gem "rails", "~> 4.2"
gem "rails-i18n", "~> 4.0"
gem "rinku", "~> 1.7"

gem "pg", "0.18.4"
gem "bcrypt", "~> 3.1"
gem "kaminari", "0.16.3"
gem "simple_form", "~> 3.1"
gem "devise", "~> 4.2"
gem "enumerize", "~> 1.0"
gem "cocoon", "~> 1.2"
gem "carrierwave", github: "carrierwaveuploader/carrierwave"
gem "mini_magick", "~> 4.2"
gem "quiet_assets", "~> 1.1"

# Frontend stuff
gem "jquery-rails", "~> 4.0"
gem "coffee-rails", "~> 4.1"
gem "bootstrap-sass", "~> 3.3"
gem "sass-rails", "~> 5.0"
gem "autoprefixer-rails", "~> 6.0"
gem "uglifier", "~> 3.0"

source "https://rails-assets.org" do
  gem "rails-assets-autosize", "~> 3.0"
end

# Translations
gem "i18n-tasks", "0.9.5"
gem "localeapp", "~> 1.0"

gem "activeadmin", "1.0.0.pre2"

gem "rubyzip", "~> 1.1", require: false
gem "ruby-progressbar", "~> 1.7", require: false

gem "slim-rails", "~> 3.0"

group :tools do
  gem "brakeman", "~> 3.1"
  gem "byebug", "~> 9.0"
  gem "factory_girl_rails", "~> 4.5"
  gem "image_optim", "0.22.1"
  gem "image_optim_pack", "0.2.1.20160510"
  gem "mdl", "0.3.1"
  gem "overcommit", "0.33.0"
  gem "rubocop", "0.40.0"
  gem "slim_lint", "0.8.0"
  gem "scss_lint", "0.48.0"
  gem "travis", "~> 1.8"
  gem "simplecov", "0.11.2"
  gem "sinatra", "~> 1.4"
end

gem "rspec-rails", "~> 3.2", groups: %i(development test)

group :development do
  gem "spring", "~> 1.3"
  gem "letter_opener", "~> 1.4"
  gem "capistrano-rails", "~> 1.1"
  gem "capistrano-passenger", "0.2.0"
  gem "unicorn-rails", "~> 2.2"
end

group :test do
  gem "capybara", "~> 2.6"
  gem "database_cleaner", "~> 1.4"
  gem "poltergeist", "~> 1.8", require: "phantomjs/poltergeist"
  gem "phantomjs", "~> 2.1"
  gem "launchy", "~> 2.4"
  gem "webmock", "~> 2.0"
  gem "shoulda-matchers", "~> 3.0"
end
