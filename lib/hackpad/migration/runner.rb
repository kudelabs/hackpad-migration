module Hackpad
  module Migration
    class Runner < Thor
      include Thor::Actions

      default_task :migrate
      desc 'migrate', 'Do migration with the config in the result, it will create a new config when you execute it at first time.'
      method_option :db, desc: 'file path for the result, default is db.json in current path.'
      def migrate
        out_file = options['db'].nil? ? 'db.json' : options['db']
        last_result = Result.new(out_file)

        begin
          Hackpad::Migration::Migrator.new(last_result).migrate
        rescue Errno::ECONNREFUSED => e
          puts e
        end
      end

      desc 'make_index', 'Create index for the pads that migrated'
      method_option :db, desc: 'file path for the result, default is db.json in current path.'
      def make_index
        out_file = options['db'].nil? ? 'db.json' : options['db']
        last_result = Result.new(out_file)
        begin
          Hackpad::Migration::Indexer.new(last_result).create
        rescue Errno::ECONNREFUSED => e
          puts e
        end
      end
    end
  end
end
