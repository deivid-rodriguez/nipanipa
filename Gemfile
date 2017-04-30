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

gem "bcrypt", "~> 3.1"
gem "carrierwave", "~> 1.0"
gem "cocoon", "~> 1.2"
gem "devise", "~> 4.2"
gem "enumerize", "~> 2.0"
gem "kaminari", "~> 1.0"
gem "mini_magick", "~> 4.2"
gem "pg", "0.20.0"
gem "simple_form", "~> 3.1"

# Frontend stuff
gem "autoprefixer-rails", "~> 6.0"
gem "bootstrap-sass", "~> 3.3"
gem "coffee-rails", "~> 4.1"
gem "jquery-rails", "~> 4.0"
gem "sass-rails", "~> 5.0"
gem "uglifier", "~> 3.0"

source "https://rails-assets.org" do
  gem "rails-assets-autosize", "~> 3.0"
end

gem "activeadmin", "~> 1.0"

gem "ruby-progressbar", "~> 1.7", require: false
gem "rubyzip", "~> 1.1", require: false

gem "slim-rails", "~> 3.0"

group :tools do
  gem "brakeman", "~> 3.1"
  gem "byebug", "~> 9.0"
  gem "factory_girl_rails", "~> 4.5"
  gem "i18n-tasks", "0.9.13"
  gem "image_optim_pack", "0.4.0"
  gem "localeapp", "~> 2.0"
  gem "mdl", "0.4.0"
  gem "overcommit", "0.39.1"
  # @todo Until https://github.com/bbatsov/rubocop/pull/4237 released
  gem "rubocop", github: "bbatsov/rubocop"
  gem "scss_lint", "0.52.0"
  gem "simplecov", "0.14.1"
  gem "slim_lint", "0.12.0"
end

gem "rspec-rails", "~> 3.2", groups: %i[development test]

group :development do
  gem "capistrano-passenger", "0.2.0"
  gem "capistrano-rails", "~> 1.1"
  gem "letter_opener", "~> 1.4"
  gem "spring", "~> 2.0"
  gem "unicorn-rails", "~> 2.2"
end

group :test do
  gem "capybara", "~> 2.6"
  gem "database_cleaner", "~> 1.4"
  gem "launchy", "~> 2.4"
  gem "poltergeist", "~> 1.8"
  gem "shoulda-matchers", "~> 3.0"
  gem "webmock", "~> 3.0"
end
