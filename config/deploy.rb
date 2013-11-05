set :application, 'nipanipa'

set :repo_url, 'git@github.com:deivid-rodriguez/nipanipa.git'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to,  '/home/deployer/nipanipa'
set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

set :linked_files, %w{config/application.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets public/uploads}

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

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'cache:clear'
      end
    end
  end

  desc 'reload the database with seed data'
  task :seed do
    on roles(:db) do
      execute "cd #{current_path} && rake db:seed RAILS_ENV=#{rails_env}"
    end
  end

  desc 'Link non-source-controlled configuration to the release'
  task :symlink_config do
    on roles(:app) do
      sudo "ln -snf #{release_path}/config/apache.conf " \
           "/etc/apache2/sites-available/nipanipa"
    end
  end
  after :finishing, 'deploy:cleanup'
  after 'deploy:cleanup', 'deploy:symlink_config'

  desc 'Make sure local git is in sync with remote'
  task :check_revision do
    on roles(:web) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "ERROR: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end
  before :deploy, 'deploy:check_revision'
end
