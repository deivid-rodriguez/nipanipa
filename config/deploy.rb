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

after "deploy:restart", "deploy:cleanup"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Copy example configuration file to the release"
  task :setup_config, roles: :app do
    sudo "ln -snf #{current_path}/config/apache.conf " \
         "/etc/apache2/sites-available/#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/application.example.yml"),
        "#{shared_path}/config/application.yml"
    puts "Now edit #{shared_path}/config/application.yml with correct settings"
  end
  after "deploy:setup", "deploy:setup_config"

  desc "Link non-source-controlled configuration to the release"
  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/application.yml " \
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
