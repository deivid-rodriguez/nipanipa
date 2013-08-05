namespace :db do
  desc 'Setup required user account for NiPaNiPa.'
  task create_user: :load_config do
    create_user
  end

  def create_user
    username = ENV['DB_USER']
    password = ENV['DB_PASS']
    sql_command = "CREATE USER #{username} CREATEDB PASSWORD \'#{password}\'"
    system "psql -c \"#{sql_command}\" -U postgres"
  end


  desc 'Kills opened pg connections'
  task kill_pg_connections: :environment do
    db_name = ENV['DB_NAME']
    system \
      "sudo kill `ps xa | grep \"[p]ostgres:.*#{db_name}\" | awk '{print $1}'`"
  end
end
