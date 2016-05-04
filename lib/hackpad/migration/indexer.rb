module Hackpad
  module Migration
    class Indexer
      attr_reader :db
      def initialize(db)
        @db = db
      end

      def create
        pads = []
        db.each_source do |source|
          db.source_and_target_map.map do |source_pid, target_pid|
            body = source.get(source_pid)
            html_doc = Nokogiri::HTML(body)
            h1 = html_doc.at_css('h1:first')
            pads << "<a href=\"#{source.client.uri}/#{source_pid}\">Original</a> | <a href=\"#{db.target.client.uri}/#{target_pid}\">Here</a> => #{h1.text}"
            STDOUT.write('.')
          end
        end
        header = "Index Page of Migration at #{Time.now}\n\n"
        content = %Q(
#{header}
<ul>
#{pads.map{ |p| "<li>#{p}</li>"}.join("\n")}
</ul>
)
        if db.index_pad
          db.target.update(db.index_pad, content)
        else
          pad = db.target.create(content)
          db.index_pad = pad['padId']
        end
        db.write!
      end
    end
  end
end
