# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# https://github.com/capistrano/bundler
require 'capistrano/bundler'

# https://github.com/capistrano/rails
require 'capistrano/rails'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
