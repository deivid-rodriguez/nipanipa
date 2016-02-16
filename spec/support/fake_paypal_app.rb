# frozen_string_literal: true

require 'sinatra/base'

#
# Simulates Paypal behaviour regarding donations
#
class FakePaypalApp < Sinatra::Base
  post %r{cgi-bin/websrc} do
    params[:cmd] == '_notify-synch' ? 'SUCCESS' : 'FAIL'
  end

  get %r{cgi-bin/websrc} do
    redirect to(params[:return])
  end
end
