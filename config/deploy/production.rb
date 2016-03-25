# frozen_string_literal: true

set :stage, :production

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each
# group is considered to be the first unless any hosts have the
# primary property set.
# role :app, %w{deploy@example.com}
# role :web, %w{deploy@example.com}
# role :db,  %w{deploy@example.com}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into
# the server list. The second argument something that quacks like
# a hash can be used to set extended properties on the server.
server "nipanipa.com", user: "deployer", roles: %w(web app db), primary: true

#
# Forward ssh agent globally for all servers
#
set :ssh_options, forward_agent: true

#
# Set default Rails environment
#
fetch(:default_env)[:rails_env] = :production
