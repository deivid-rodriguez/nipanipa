set :application, 'nipanipa'

set :repo_url, 'git@github.com:deivid-rodriguez/nipanipa.git'
set :branch, 'master'

set :deploy_to,  '/home/deployer/nipanipa'
set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

set :linked_files, %w(config/application.yml)
set :linked_dirs, %w(bin log tmp/pids tmp/cache tmp/sockets public/uploads)

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do
  desc 'Stop Passenger'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('/tmp/stop.txt')
    end
  end

  desc 'Start (or un-stop) Passenger'
  task :start do
    on roles(:app) do
      execute :rm, '-f', "#{release_path}/tmp/stop.txt"
    end
  end

  desc 'Restart Passenger'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('/tmp/restart.txt')
    end
  end

  desc 'reload the database with seed data'
  task :seed do
    on roles(:db) do
      execute "cd #{current_path} && rake db:seed RAILS_ENV=#{rails_env}"
    end
  end

  after :finishing, 'deploy:cleanup'

  desc 'Make sure local git is in sync with remote'
  task :check_revision do
    on roles(:web) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        errmsg = 'HEAD not the same as origin/master. Run `git push` to sync.'
        fail(errmsg)
      end
    end
  end
  before :deploy, 'deploy:check_revision'
end
