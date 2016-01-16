require 'rack'

#
# Redirects all request to the default capybara app, unless the port is
# configured to redirect to a different rack app.
#
class PortMapper
  def initialize(default_app, mappings)
    @default_app = default_app
    @mappings = mappings
  end

  def call(env)
    port = Rack::Request.new(env).port

    (@mappings[port] || @default_app).call(env)
  end
end
