# frozen_string_literal: true

namespace :yarn do
  desc "Installs JS libraries through yarn"
  task :install do
    on :all do
      within release_path do
        unless test(:yarn, :check, "--silent")
          execute :yarn, :install, "--production", "--silent"
        end
      end
    end
  end
end
