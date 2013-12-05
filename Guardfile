require 'active_support/inflector'

#
# More info at https://github.com/guard/guard#readme
#
guard :rspec, fail_mode: :keep, all_on_start: true,
              cmd: 'rspec --colour --fail-fast' do

  watch(%r{^config/locales/.*\.yml$})             { 'spec/features' }
  watch(%r{^config/environments/test.rb$})        { 'spec'          }
  watch(%r{^config/environments/development.rb$}) { 'spec'          }
  watch(%r{^config/.*\.rb$})                      { 'spec'          }

  watch(%r{^app/models/(.+)\.rb}) { |m|
    ["spec/models/#{m[1]}_spec.rb", "spec/features/#{m[1]}_spec.rb"] }

  watch(%r{^app/controllers/(.+)_controller\.rb$}) { |m|
    ["spec/features/#{m[1]}_spec.rb", "spec/controllers/#{m[1]}_spec.rb"] }

  watch(%r{^app/views/(.+)/}) { |m| "spec/features/#{m[1]}_spec.rb" }

  watch('app/controllers/application_controller.rb') { 'spec/controllers' }
  watch('app/helpers/application_helper.rb')         { 'spec/features'    }

  # Reload specs when changing them
  watch('spec/factories.rb')           { 'spec' }
  watch(%r{^spec/support/.*\.rb$})     { 'spec' }

  watch(%r{^spec/([^/]+)/(.+)_spec\.rb$}) { |m| "spec/#{m[1]}/#{m[2]}_spec.rb" }
end
