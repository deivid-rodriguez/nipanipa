class SpoofIp

  def initialize(app, ip)
    @app = app
    @ip  = ip
  end

  def call(env)
    env['HTTP_X_REAL_IP'] = @ip
    @status, @headers, @response = @app.call(env)
    [ @status, @headers, @response ]
  end

end
