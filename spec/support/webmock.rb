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
  stubs.each { |uri, path|
    WebMock::API.stub_request(:get, uri).to_return(File.new(path)) }

  WebMock.disable_net_connect!(allow_localhost: true)


end
