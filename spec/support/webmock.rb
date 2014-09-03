require 'webmock'

RSpec.configure do |_config|
  dir = "#{::Rails.root}/spec/webmock"
  stubs = {}
  Dir["#{dir}/**/*"].each do |path|
    next if File.directory? path
    uri = path.dup
    uri.slice!("#{dir}/")
    uri = File.dirname(uri) + '/' if File.basename(uri) == '_directory'
    stubs["http://#{uri}"] = path
  end

  # Stub Geolocation Requests
  stubs.each do |uri, path|
    WebMock::API.stub_request(:get, uri).to_return(File.new(path))
  end

  # Stub Paypal Redirection
  WebMock::API.stub_request(:get, /.*sandbox\.paypal\.com.*/)
              .to_return(status: 200, body: '', headers: {})

  WebMock.disable_net_connect!(allow_localhost: true)
end

def paypal_signature
  'jpnQ%2fNXbC0KdUzVDVMxw%2fGr1RxxvWDIqwlNT9W6f0lxGH66BxUIhzRj8vJW8jwh0DVqyE' \
  '4ZUaxHTmQVry2yxR5bR8ge3kA1tVgo9Qc5%2bU2ErQVmvOJ555ABbqk4pMbBG7qaHNkqxD33J' \
  'Zk%2f3Hl9bnBj46gztBvlnYuxd5jGRP8Q%3d'
end

def paypal_tx
  '4YD48288L7608774D'
end

def mock_paypal_pdt(status, donation_id)
  WebMock::API.stub_request(:post, ENV['PAYPAL_URL'])
    .with(body: { at: ENV['PAYPAL_PDT_AT'],
                  cmd: '_notify-synch',
                  tx: paypal_tx },
          headers: { 'Accept'       => '*/*',
                     'Content-Type' => 'application/x-www-form-urlencoded',
                     'User-Agent'   => 'Ruby' })
    .to_return(status: 200, body: "#{status}", headers: {})

  visit "/en/donations/#{donation_id}?tx=4YD48288L7608774D&st=Completed&amt=" \
        "20.00&cc=USD&cm=&item_number=&sig=#{paypal_signature}" \
end
