# frozen_string_literal: true

set :application, "nipanipa"

set :repo_url, "git@github.com:deivid-rodriguez/nipanipa.git"
set :branch, "master"

set :deploy_to, "/home/deployer/nipanipa"
set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

set :linked_files, %w(config/application.yml)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets public/uploads)

set :keep_releases, 5

set :bundle_without, "development test tools"

namespace :deploy do
  desc "Reload the database with seed data"
  task :seed do
    on roles(:db) do
      execute "cd #{current_path} && rake db:seed RAILS_ENV=#{rails_env}"
    end
  end

  after :finishing, "deploy:cleanup"

  desc "Make sure local git is in sync with remote"
  task :check_revision do
    on roles(:web) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        errmsg = "HEAD not the same as origin/master. Run `git push` to sync."
        raise(errmsg)
      end
    end
  end
  before :deploy, "deploy:check_revision"

  desc "Show changes to be deployed"
  task :pending do
    on roles(:app) do
      within repo_path do
        info `git diff #{strategy.fetch_revision} master`
      end
    end
  end
end
