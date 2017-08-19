# frozen_string_literal: true

# TODO: Revisit the warnings fixed by this in Bundler 2, I guess they will be
# fixed and this won't be needed
#
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")

  "https://github.com/#{repo_name}.git"
end

source "https://rubygems.org"

gem "mail", "~> 2.7.x" # TODO: Until mail 2.7.0 released
gem "rails", "~> 5.1"
gem "rails-i18n", "~> 5.0"
gem "rinku", "~> 2.0"

gem "dotenv-rails", "~> 2.1"

gem "bcrypt", "~> 3.1"
gem "carrierwave", "~> 1.0"
gem "cocoon", "~> 1.2"
gem "devise", "~> 4.2"
gem "enumerize", "~> 2.0"
gem "kaminari", "~> 1.0"
gem "mini_magick", "~> 4.8"
gem "pg", "0.21.0"
gem "simple_form", "~> 3.1"

# Frontend stuff
gem "autoprefixer-rails", "~> 7.1"
gem "bootstrap-sass", "~> 3.3"
gem "coffee-rails", "~> 4.1"
gem "jquery-rails", "~> 4.0"
gem "sass-rails", "~> 5.0"
gem "uglifier", "~> 3.0"

gem "activeadmin", "~> 1.1"

gem "ruby-progressbar", "~> 1.7", require: false
gem "rubyzip", "~> 1.1", require: false

gem "slim-rails", "~> 3.0"

group :tools do
  gem "byebug", "~> 9.0"
  gem "factory_girl_rails", "~> 4.5"
  gem "i18n-tasks", "0.9.18"
  gem "image_optim_pack", "0.5.0.20170803"
  gem "overcommit", "0.40.0"
  gem "rubocop", "0.49.1"
  gem "simplecov", "0.14.1"
  gem "slim_lint", "0.13.0"
  gem "squasher", "0.4.0"
end

gem "rspec-rails", "~> 3.2", groups: %i[development test]

group :deploy do
  gem "capistrano-passenger", "0.2.0"
  gem "capistrano-pending", "0.2.0"
  gem "capistrano-rails", "~> 1.1"
end

group :development do
  gem "letter_opener", "~> 1.4"
  gem "localeapp", "~> 2.0"
  gem "spring", "~> 2.0"
  gem "unicorn-rails", "~> 2.2"
end

group :test do
  gem "capybara", "~> 2.15"
  gem "database_cleaner", "~> 1.4"
  gem "launchy", "~> 2.4"
  gem "selenium-webdriver", "~> 3.4"
  gem "shoulda-matchers", "~> 3.1"
  gem "webmock", "~> 3.0"
end
