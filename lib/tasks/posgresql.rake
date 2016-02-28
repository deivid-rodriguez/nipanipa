# frozen_string_literal: true

#
# Tasks for taking & restoring db snapshots
#
namespace :db do
  desc "Dumps the database to a file."
  task dump: :environment do
    cmd = <<~SHELL
      PGPASSWORD=#{config[:password]} \
      pg_dump \
        --port #{config[:port]} \
        --host #{config[:host]} \
        --username #{config[:username]} \
        --clean \
        --no-owner \
        --no-acl \
        --format=c \
        -n public \
        #{config[:database]} > #{Rails.root}/db/snapshot.dump
    SHELL

    puts "Dumping #{Rails.env} database."

    raise unless system(cmd)
  end

  desc "Restores database from a file."
  task restore: [:environment, :drop, :create] do
    cmd = <<~SHELL
      PGPASSWORD=#{config[:password]} \
      pg_restore \
        --port=#{config[:port]} \
        --host=#{config[:host]} \
        --username=#{config[:username]} \
        --no-owner \
        --no-acl \
        -n public \
        --dbname=#{config[:database]} #{Rails.root}/db/snapshot.dump
    SHELL

    puts "Restoring #{Rails.env} database."

    raise unless system(cmd)
  end

  private

  def config
    @config ||= ActiveRecord::Base.connection_config
  end
end
