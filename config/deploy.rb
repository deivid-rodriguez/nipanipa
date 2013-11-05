require 'bundler/capistrano'

server '192.81.212.5', :web, :app, :db, primary: true

set :application, "nipanipa"
set :user, "deployer"
set :deploy_to,  "/home/#{user}/#{application}"
set :deploy_via, :remote_cache

set :scm, :git
set :repository, "git@github.com:deivid-rodriguez/#{application}.git"
set :branch, "master"

set :use_sudo, false

set :shared_children, shared_children + %w{public/uploads}

after "deploy:restart", "deploy:cleanup"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

namespace :deploy do
  desc 'Stop Passenger'
  task :stop, roles: :app do
    run "touch #{current_path}/tmp/stop.txt"
  end

  desc 'Start (or un-stop) Passenger'
  task :start, roles: :app do
    run "rm -f #{current_path}/tmp/stop.txt"
  end

  desc 'Restart Passenger'
  task :restart, roles: :app, except: { no_release: true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "reload the database with seed data"
  task :seed, roles: :db do
    run "cd #{current_path} && bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end

  desc "Copy example configuration file to the release"
  task :setup_config, roles: :app do
    run "mkdir -p #{shared_path}/config"
    put File.read("config/application.example.yml"),
        "#{shared_path}/config/application.yml"
    puts "Now edit #{shared_path}/config/application.yml with correct settings"
  end
  after "deploy:setup", "deploy:setup_config"

  desc "Link non-source-controlled configuration to the release"
  task :symlink_config, roles: :app do
    sudo "ln -snf #{release_path}/config/apache.conf " \
         "/etc/apache2/sites-available/#{application}"
    run "ln -snf #{shared_path}/config/application.yml " \
                "#{release_path}/config/application.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "ERROR: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
  before "deploy:cold", "deploy:check_revision"
end
