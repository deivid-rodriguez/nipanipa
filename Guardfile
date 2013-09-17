require 'active_support/inflector'

#
# More info at https://github.com/guard/guard#readme
#
guard :rspec, spring: true, keep_failed: true, all_on_start: true,
              cli: '--colour --fail-fast' do

  watch(%r{^config/locales/.*\.rb$})              { 'spec/features' }
  watch(%r{^config/environments/test.rb$})        { 'spec'          }
  watch(%r{^config/environments/development.rb$}) { 'spec'          }
  watch(%r{^config/.*\.rb$})                      { 'spec'          }

  watch(%r{^app/models/(.+)\.rb}) { |m|
    ["spec/models/#{m[1]}_spec.rb", "spec/features/#{m[1]}_pages_spec.rb"] }

  watch(%r{^app/(.+)\.rb$})           { |m| "spec/#{m[1]}_spec.rb"        }
  watch(%r{^app/(.*)(\.erb|\.haml)$}) { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }

  watch(%r{^app/controllers/(.+)_controller\.rb$}) { |m|
    m[1][/_pages/] ? "spec/features/#{m[1]}_spec.rb" :
                     "spec/features/#{m[1].singularize}_pages_spec.rb" }

  watch('app/controllers/application_controller.rb') { 'spec/controllers' }
  watch('app/helpers/application_helper.rb')         { 'spec/features'    }

  # Capybara features specs
  watch(%r{^app/views/(.+)/}) { |m|
    m[1][/_pages/] ? "spec/features/#{m[1]}_spec.rb" :
                     "spec/features/#{m[1].singularize}_pages_spec.rb" }

  # Reload specs when changing them
  watch('spec/factories.rb')       { 'spec' }
  watch(%r{^spec/support/.*\.rb$}) { 'spec' }
  watch(%r{^spec/.+_spec\.rb$})
end

guard 'rails' do
  watch('Gemfile.lock')
  watch(%r{^(config|lib)/.*})
end
