# frozen_string_literal: true

require File.expand_path("../config/application", __FILE__)

Rails.application.load_tasks

if %w[development test].include?(Rails.env)
  require "rubocop/rake_task"
  RuboCop::RakeTask.new

  require "slim_lint/rake_task"
  SlimLint::RakeTask.new { |t| t.files = ["app/views"] }

  task default: :spec
end
