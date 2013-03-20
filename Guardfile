# A sample Guardfile
# More info at https://github.com/guard/guard#readme
#
require 'active_support/core_ext'

guard 'spork', :rspec => true, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb')
  watch(%r{^spec/support/.+\.rb$})
end

guard 'rspec', :all_after_pass => false, :cli => '--drb' do
  watch('spec/factories.rb')
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }

  # Rails example
  watch(%r{^app/models/(.+)\.rb}) { |m|
    ["spec/models/#{m[1]}_spec.rb", "spec/features/#{m[1]}_pages_spec.rb"]  }
  watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$}) { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do |m|
    ["spec/routing/#{m[1]}_routing_spec.rb",
     "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
     "spec/acceptance/#{m[1]}_spec.rb",
     (m[1][/_pages/] ? "spec/features/#{m[1]}_spec.rb" :
                       "spec/features/#{m[1].singularize}_pages_spec.rb")]
  end
  watch(%r{^spec/support/(.+)\.rb$}) { "spec" }
  watch('config/routes.rb') { "spec" }
  watch('app/controllers/application_controller.rb') { "spec/controllers" }

  # Capybara features specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$}) {
    |m| "spec/features/#{m[1]}_spec.rb" }
  watch(%r{^app/views/(.+)/}) do |m|
    (m[1][/_pages/] ? "spec/features/#{m[1]}_spec.rb" :
                      "spec/features/#{m[1].singularize}_pages_spec.rb")
  end

  # Reload specs when changing them
  watch(%r{^spec/(.+)/(.+)_spec\.rb$}) { "spec/#{m[1]}/#{m[2]}_spec.rb" }

end
