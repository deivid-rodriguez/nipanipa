# frozen_string_literal: true

#
# Simulates Paypal behaviour regarding donations
#
class FakePaypalApp
  def call(env)
    return unless env["PATH_INFO"].match?(%r{cgi-bin/websrc})

    case env["REQUEST_METHOD"]
    when "POST" then notify(env)
    when "GET" then redirect(env)
    end
  end

  private

  def redirect(env)
    get_params = Rack::Utils.parse_query(env["QUERY_STRING"])

    [302, { "Location" => get_params["return"] }, []]
  end

  def notify(env)
    post_params = Rack::Utils.parse_query(env["rack.input"].gets)

    [200, {}, [post_params["cmd"] == "_notify-synch" ? "SUCCESS" : "FAIL"]]
  end
end
