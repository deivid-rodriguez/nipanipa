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
end
