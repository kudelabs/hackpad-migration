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
        source.list.each do |source_pid|
          body = source.get(source_pid)
          # pad {"padId"=>"RAtutOXxMGF1", "globalPadId"=>"2$RAtutOXxMGF1"}
          target_pid = result.source_and_target_map[source_pid]
          if target_pid.nil?
            pad = target.create(body)
            result.add_source_and_target(source_pid, pad['padId'])
            puts "created pad #{pad['padId']} from source pad #{source_pid}"
            result.write!
          else
            puts "Updating pad #{target_pid} from source pad #{source_pid}"
            pad = target.update(target_pid, body)
          end
        end
      end
    end
  end
end
