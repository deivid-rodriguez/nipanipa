#
# More info at https://github.com/guard/guard#readme
#
guard :rspec, cmd: 'bin/rspec', all_on_start: true do
  watch(/^spec\/.+_spec\.rb$/)
  watch(/^lib\/(.+)\.rb$/) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { 'spec' }

  # Rails example
  watch(/^app\/(.+)\.rb$/) { |m| "spec/#{m[1]}_spec.rb" }
  watch(/^app\/(.*)\.erb$/) { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do |m|
    "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb"
  end
  watch(%r{^spec/support/(.+)\.rb$}) { 'spec' }
  watch('app/controllers/application_controller.rb') { 'spec/controllers' }
  watch('spec/rails_helper.rb') { 'spec' }

  # Capybara features specs
  watch(%r{^app/views/(.+)/.*\.erb$}) { |m| "spec/features/#{m[1]}_spec.rb" }

  watch(%r{^spec/factories/(.+)\.rb$}) { |m| "spec/models/#{m[1]}.rb" }
end

guard :livereload do
  watch(%r{app/views/.+\.erb$})
  watch(%r{app/helpers/.+\.rb})
  watch(/^public\/.+\.(css|js|html)$/)
  watch(%r{config/locales/.+\.yml})

  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html|png|jpg))).*}) do |m|
    "/assets/#{m[3]}"
  end
end
