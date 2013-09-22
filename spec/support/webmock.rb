require 'webmock'

RSpec.configure do |config|
  dir = "#{::Rails.root}/spec/webmock"
  stubs = {}
  Dir["#{dir}/**/*"].each do |path|
    next if File.directory? path
    uri = path.dup
    uri.slice!("#{dir}/")
    if File.basename(uri) == '_directory'
      uri = File.dirname(uri)+'/'
    end
    stubs["http://#{uri}"] = path
  end

  # Stub Geolocation Requests
  stubs.each { |uri, path|
    WebMock::API.stub_request(:get, uri).to_return(File.new(path)) }

  # Stub Paypal Redirection
  WebMock::API.stub_request(:get, /.*sandbox\.paypal\.com.*/)
              .to_return(status: 200, body: '', headers: {})

  WebMock.disable_net_connect!(allow_localhost: true)
end

def mock_paypal_pdt(status, donation_id)
  WebMock::API.
    stub_request(:post, ENV['PAYPAL_URL']).
      with(body: { at: ENV['PAYPAL_PDT_AT'],
                  cmd: "_notify-synch",
                   tx: "4YD48288L7608774D" },
           headers: { 'Accept'       => '*/*',
                      'Content-Type' => 'application/x-www-form-urlencoded',
                      'User-Agent'   => 'Ruby'}).
      to_return(status: 200, body: "#{status}", headers: {})

  visit "/donations/#{donation_id}?tx=4YD48288L7608774D&st=Completed&amt=20.0" \
        "0&cc=USD&cm=&item_number=&sig=jpnQ%2fNXbC0KdUzVDVMxw%2fGr1RxxvWDIqwl" \
        "NT9W6f0lxGH66BxUIhzRj8vJW8jwh0DVqyE4ZUaxHTmQVry2yxR5bR8ge3kA1tVgo9Qc" \
        "5%2bU2ErQVmvOJ555ABbqk4pMbBG7qaHNkqxD33JZk%2f3Hl9bnBj46gztBvlnYuxd5j" \
        "GRP8Q%3d"
end
