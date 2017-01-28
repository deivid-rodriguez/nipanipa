# frozen_string_literal: true

# @todo Revisited the warnings fixed by this in Bundler 2, I guess they will be
# fixed and this won't be needed
#
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")

  "https://github.com/#{repo_name}.git"
end

source "https://rubygems.org"

gem "rails", "~> 5.0"
gem "rails-i18n", "~> 5.0"
gem "rinku", "~> 2.0"

gem "dotenv-rails", "~> 2.1"

gem "pg", "0.19.0"
gem "bcrypt", "~> 3.1"
gem "kaminari", "0.17.0"
gem "simple_form", "~> 3.1"
gem "devise", "~> 4.2"
gem "enumerize", "~> 2.0"
gem "cocoon", "~> 1.2"
gem "carrierwave", github: "carrierwaveuploader/carrierwave"
gem "mini_magick", "~> 4.2"

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
gem "i18n-tasks", "0.9.6"
gem "localeapp", "~> 2.0"

gem "activeadmin", github: "activeadmin"
gem "inherited_resources", github: "activeadmin/inherited_resources"

gem "rubyzip", "~> 1.1", require: false
gem "ruby-progressbar", "~> 1.7", require: false

gem "slim-rails", "~> 3.0"

group :tools do
  gem "brakeman", "~> 3.1"
  gem "byebug", "~> 9.0"
  gem "factory_girl_rails", "~> 4.5"
  gem "image_optim", "0.24.0"
  gem "image_optim_pack", "0.3.0.20161021"
  gem "mdl", "0.4.0"
  gem "overcommit", "0.37.0"
  gem "rubocop", "0.45.0"
  gem "slim_lint", "0.8.2"
  gem "scss_lint", "0.50.3"
  gem "travis", "~> 1.8"
  gem "simplecov", "0.13.0"
end

gem "rspec-rails", "~> 3.2", groups: %i(development test)

group :development do
  gem "spring", "~> 2.0"
  gem "letter_opener", "~> 1.4"
  gem "capistrano-rails", "~> 1.1"
  gem "capistrano-passenger", "0.2.0"
  gem "unicorn-rails", "~> 2.2"
end

group :test do
  gem "capybara", "~> 2.6"
  gem "database_cleaner", "~> 1.4"
  gem "poltergeist", "~> 1.8"
  gem "launchy", "~> 2.4"
  gem "webmock", "~> 2.0"
  gem "shoulda-matchers", "~> 3.0"
end
