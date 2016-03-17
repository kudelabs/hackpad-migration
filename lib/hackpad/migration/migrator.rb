module Hackpad
  module Migration
    class Migrator
      attr_reader :source, :target, :result
      def initialize(last_result)
        options = last_result.user_options
        @source = API.new(options['source_site'], options['source_client_id'], options['source_secret'])
        @target = API.new(options['target_site'], options['target_client_id'], options['target_secret'])
        @result = last_result
      end

      def migrate
        pad_list = source.list
        exit_if_error(pad_list, 'Get error when fetching pad list from source site')
        pad_list.each do |source_pid|
          body = source.get(source_pid)
          unless body[/You'll need to turn on JavaScript to use Hackpad in all of its/].nil?
            puts "WARNING: the pad from source #{source_pid} seems not found."
          end
          target_pid = result.source_and_target_map[source_pid]
          if target_pid.nil?
            pad = target.create(body)
            exit_if_error(pad, 'Got error when creating pad for target site')
            # pad {"padId"=>"RAtutOXxMGF1", "globalPadId"=>"2$RAtutOXxMGF1"}
            result.add_source_and_target(source_pid, pad['padId'])
            puts "created pad #{pad['padId']} from source pad #{source_pid}"
            result.write!
          else
            puts "Updating pad #{target_pid} from source pad #{source_pid}"
            pad = target.update(target_pid, body)
            exit_if_error(pad, 'Got error when update pad for target site')
          end
        end
      end

      def exit_if_error(result, msg)
        if result.is_a?(Hash) && !result['success']
          puts "#{msg}, #{result['error']}"
          exit(1)
        end
      end
    end
  end
end
