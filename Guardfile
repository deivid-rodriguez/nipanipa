require 'active_support/inflector'

#
# More info at https://github.com/guard/guard#readme
#
guard :rspec, spring: true,
              keep_failed: true,
              all_on_start: true,
              cli: '--colour' do

  watch(%r{^config/locales/(.*)\.rb$}) { |m| "spec/features" }

  watch(%r{^app/models/(.+)\.rb}) { |m|
    ["spec/models/#{m[1]}_spec.rb", "spec/features/#{m[1]}_pages_spec.rb"] }

  watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$}) { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do |m|
    ["spec/routing/#{m[1]}_routing_spec.rb",
     "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
     "spec/acceptance/#{m[1]}_spec.rb",
     (m[1][/_pages/] ? "spec/features/#{m[1]}_spec.rb" :
                       "spec/features/#{m[1].singularize}_pages_spec.rb")]
  end
  watch('app/controllers/application_controller.rb') { "spec/controllers" }
  watch('app/helpers/application_helper.rb') { 'spec/features' }

  # Capybara features specs
  watch(%r{^app/views/(.+)/}) do |m|
    m[1][/_pages/] ? "spec/features/#{m[1]}_spec.rb" :
                     "spec/features/#{m[1].singularize}_pages_spec.rb"
  end

  # Reload specs when changing them
  watch('spec/factories.rb') { "spec" }
  watch(%r{^spec/(.+)/(.+)_spec\.rb$}) { |m| "spec/#{m[1]}/#{m[2]}_spec.rb" }
end
