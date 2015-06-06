require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

if %w(development test).include?(Rails.env)
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  task default: [:spec, :rubocop]
  require 'slim_lint/rake_task'
  SlimLint::RakeTask.new

  task default: [:spec, :rubocop, :slim_lint]
end
