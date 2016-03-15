module Hackpad
  module Migration
    class Runner < Thor
      include Thor::Actions

      default_task :migrate
      desc 'migrate', 'start migration with output file'
      # method_option :source_site, desc: 'The source site for migration', required: true
      # method_option :source_client_id, desc: 'Hackpad client id for source site', required: true
      # method_option :source_secret, desc: 'Hackpad secret key for source site', required: true
      # method_option :target_site, desc: 'The target site for migration', required: true
      # method_option :target_client_id, desc: 'Hackpad client id for target site', required: true
      # method_option :target_secret, desc: 'Hackpad secret key for target site', required: true
      method_option :output, desc: 'file path for the result'
      def migrate
        out_file = options['output'].nil? ? 'result.json' : options['output']
        last_result = Result.new(out_file)
        if last_result.user_options['source_site'].nil?
          last_result.user_options['source_site'] = ask 'Please entry the source site that you want to migrate (example: https://example.hackpad.com): '
          last_result.write!
        end
        if last_result.user_options['source_client_id'].nil?
          last_result.user_options['source_client_id'] = ask 'Please entry the client id that you want to migrate (example: xLR8qInsYLG): '
          last_result.write!
        end
        if last_result.user_options['source_secret'].nil?
          last_result.user_options['source_secret'] = ask 'Please entry the secret that you want to migrate (example: XsDYswLE1QogALkdFgsfvhRW4YJUvGre): '
          last_result.write!
        end
        if last_result.user_options['target_site'].nil?
          last_result.user_options['target_site'] = ask 'Please entry the target site that you want to migrate (example: https://example.hackpad.com): '
          last_result.write!
        end
        if last_result.user_options['target_client_id'].nil?
          last_result.user_options['target_client_id'] = ask 'Please entry the client id that you want to migrate (example: xLR8qInsYLG): '
          last_result.write!
        end
        if last_result.user_options['target_secret'].nil?
          last_result.user_options['target_secret'] = ask 'Please entry the secret that you want to migrate (example: XsDYswLE1QogALkdFgsfvhRW4YJUvGre): '
          last_result.write!
        end
        Hackpad::Migration::Migrator.new(last_result).migrate
      end

      def help
        super
        puts "example:"
        puts "hackpad-migrate start --source-site=https://donikude.hackpad.com --source-client-id=xLR8qInsYLG --source-secret=d29BpvU9iFfsrhH1iuZhjaDeK5GfKZcJ --target-site=http://localhost:9000 --target-client-id=CMjaMB5IrOz --target-secret=XsDYswLE1QogALkdFgsfvhRW4YJUvGre"
      end
    end
  end
end
