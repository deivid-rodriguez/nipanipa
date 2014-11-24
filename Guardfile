#
# More info at https://github.com/guard/guard#readme
#
group :red_green_refactor, halt_on_fail: true do
  guard :rspec, cmd: 'bin/rspec',
                all_on_start: true,
                failed_mode: :keep,
                all_after_pass: true do
    watch(/^spec\/.+_spec\.rb$/)
    watch(/^lib\/(.+)\.rb$/) { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { 'spec' }

    # Rails example
    watch(/^app\/(.+)\.rb$/) { |m| "spec/#{m[1]}_spec.rb" }
    watch(/^app\/(.*)\.slim$/) { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do |m|
      "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb"
    end
    watch(%r{^spec/support/(.+)\.rb$}) { 'spec' }
    watch('app/controllers/application_controller.rb') { 'spec/controllers' }
    watch('spec/rails_helper.rb') { 'spec' }

    # Capybara features specs
    watch(%r{^app/views/(.+)/.*\.slim$}) { |m| "spec/features/#{m[1]}_spec.rb" }

    watch(%r{^spec/factories/(.+)\.rb$}) { |m| "spec/models/#{m[1]}.rb" }
  end

  guard :rubocop, cli: %w(-D) do
    watch(/.+\.rb$/)
    watch(/\.rubocop\.yml$/) { |m| File.dirname(m[0]) }
  end

  guard :scsslint do
    watch(/.+\.scss$/)
    watch(/\.scss-lint\.yml$/) { |m| File.dirname(m[0]) }
  end
end

guard :livereload do
  watch(%r{app/views/.+\.slim$})
  watch(%r{app/helpers/.+\.rb})
  watch(/^public\/.+\.(css|js|html)$/)
  watch(%r{config/locales/.+\.yml})

  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html|png|jpg))).*}) do |m|
    "/assets/#{m[3]}"
  end
end
