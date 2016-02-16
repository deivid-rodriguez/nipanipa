# frozen_string_literal: true

#
# DB management related tasks
#
namespace :db do
  desc 'Setup required user account for NiPaNiPa.'
  task create_user: :load_config do
    username = ENV['DB_USER']
    password = ENV['DB_PASS']
    sql_command = "CREATE USER #{username} CREATEDB PASSWORD \'#{password}\'"
    system "psql -c \"#{sql_command}\" -U postgres"
  end
end
