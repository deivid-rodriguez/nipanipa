#
# More info at https://github.com/guard/guard#readme
#
group :red_green_refactor, halt_on_fail: true do
  guard :rspec, cmd: 'bin/rspec',
                failed_mode: :keep,
                all_after_pass: true do
    watch(/^spec\/.+_spec\.rb$/)

    watch('spec/spec_helper.rb') { 'spec' }
    watch('spec/rails_helper.rb') { 'spec' }
    watch(/^spec\/support.+\.rb$/) { 'spec' }

    watch(%r{app/models/(.+)\.rb$}) { |m| "spec/models/#{m[1]}_spec.rb" }
    watch(%r{spec/factories/(.+)\.rb$}) { |m| "spec/models/#{m[1]}_spec.rb" }

    watch(%r{app/controllers/(.+)_controller\.rb$}) do |m|
      "spec/features/#{m[1]}_spec.rb"
    end
    watch('app/controllers/application_controller.rb') { 'spec/controllers' }

    watch(%r{app/views/(.+)/.*\.slim$}) { |m| "spec/features/#{m[1]}_spec.rb" }

    watch(/^config\/locales.*$/) { 'spec/i18n_spec.rb' }
  end

  guard :rubocop, cli: %w(-D) do
    watch(/.+\.rb$/)
    watch(/(?:.+\/)?\.rubocop\.yml$/) { |m| File.dirname(m[0]) }
  end
end

guard :livereload do
  watch(%r{app/views/.+\.slim$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{config/locales/.+\.yml})

  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(scss|js|html|png))).*}) do |m|
    "/assets/#{m[3]}"
  end
end
