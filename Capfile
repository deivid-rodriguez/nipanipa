# frozen_string_literal: true

# Load DSL and Setup Up Stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Make git commands available
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Rails tasks
require "capistrano/rails"

# Restart passenger after deployments
require "capistrano/passenger"

# Show pending stuff to be deployed
require "capistrano/pending"
