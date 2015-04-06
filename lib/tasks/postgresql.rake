namespace :db do
  desc 'Kills opened pg connections'
  task kill_pg_connections: :environment do
    db_name = ENV['DB_NAME']
    system \
      "sudo kill `ps xa | grep \"[p]ostgres:.*#{db_name}\" | awk '{print $1}'`"
  end
end
