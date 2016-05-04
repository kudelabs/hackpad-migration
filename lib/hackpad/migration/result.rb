module Hackpad
  module Migration
    class Result
      def initialize(out_file)
        unless File.exist?(out_file)
          STDERR.puts "ERROR: db file #{out_file} not found!"
          exit(-1)
        end
        @out_file = out_file
      end

      def each_source
        _db['sources'].each do |s|
          @current_source = s
          yield API.new(s['site'], s['client_id'], s['secret'])
        end
      end

      def index_pad
        _db['index_pad']
      end

      def index_pad=(pid)
        _db['index_pad'] = pid
      end

      def target
        t = _db['target']
        @target ||= API.new(t['site'], t['client_id'], t['secret'])
      end

      def _db
        @db ||= File.exist?(@out_file) ? JSON.parse(open(@out_file).read) : {}
      end

      def write!
        open(@out_file, 'w+') do |f|
          f.write(to_json)
        end
      end

      def source_and_target_map
        @current_source['source_and_target_map'] ||= {}
      end

      def add_source_and_target(source, target)
        @current_source['updated_at'] = Time.now
        source_and_target_map[source] = target
      end

      def to_json
        JSON.pretty_generate(_db)
      end
    end
  end
end
