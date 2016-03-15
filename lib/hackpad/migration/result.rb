module Hackpad
  module Migration
    class Result
      def initialize(out_file)
        @out_file = out_file
      end

      def result
        @result ||= File.exist?(@out_file) ? JSON.parse(open(@out_file).read) : {}
      end

      def write!
        open(@out_file, 'w+') do |f|
          f.write(to_json)
        end
      end

      def user_options
        @user_options ||= result['user_options'] || {}
      end

      def source_and_target_map
        @source_and_target_map ||= result['source_and_target_map'] || {}
      end

      def add_user_option(key, vlaue)
        user_options[key] = value
      end

      def add_source_and_target(source, target)
        source_and_target_map[source] = target
      end

      def to_json
        JSON.pretty_generate(
          user_options: user_options,
          source_and_target_map: source_and_target_map,
          updated_at: Time.now
        )
      end
    end
  end
end
