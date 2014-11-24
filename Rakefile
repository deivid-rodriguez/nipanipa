require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

if %w(development test).include?(Rails.env)
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  require 'scss_lint/rake_task'
  SCSSLint::RakeTask.new

  task default: [:spec, :rubocop, :scss_lint]
end
