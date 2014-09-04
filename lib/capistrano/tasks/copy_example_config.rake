desc 'Copy example configuration file to the release'
task :setup_config do
  on roles(:app) do
    execute :mkdir, "-p #{shared_path}/config"
    put File.read("config/application.example.yml"),
        "#{shared_path}/config/application.yml"
    puts "Now edit #{shared_path}/config/application.yml with correct settings"
  end
end
