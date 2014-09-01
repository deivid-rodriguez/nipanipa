# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# https://github.com/capistrano/bundler
require 'capistrano/bundler'

# https://github.com/capistrano/rails
require 'capistrano/rails'

# https://github.com/rmv/rvm1-capistrano3
require 'rvm1/capistrano3'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
