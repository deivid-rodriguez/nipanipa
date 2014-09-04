# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Rails tasks
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

# Rvm tasks
require 'capistrano/rvm'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
