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
end
