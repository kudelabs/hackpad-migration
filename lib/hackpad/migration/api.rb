module Hackpad
  module Migration
    class API
      attr_reader :client
      def initialize(site, client_id, secret)
        @client = OAuth::Consumer.new(client_id, secret, site: site)
      end

      def list
        JSON.parse(client.request(:get, '/api/1.0/pads/all').body)
      end

      def get(id)
        body = client.request(:get, "/api/1.0/pad/#{id}/content/latest.html").body
        html_doc = Nokogiri::HTML(body)
        fix_data_missing(body)
        h1 = html_doc.at_css('h1:first')
        header = h1 ? h1.text + "\n" : ''
        begin
          header + body
        rescue
          body
        end
      end

      def create(body)
        JSON.parse(client.request(:post, '/api/1.0/pad/create', nil, {}, body, {
                                    'Content-Type' => 'text/html'
                                  }).body)
      end

      def update(pid, body)
        JSON.parse(client.request(:post, "/api/1.0/pad/#{pid}/content", nil, {}, body, {
                                    'Content-Type' => 'text/html'
                                  }).body)
      end

      private
      def fix_data_missing(body)
        body.gsub!('class="taskdone"', 'class="listtype-taskdone listindent2 list-taskdone2"')
        body.gsub!('class="task"', 'class="listtype-task listindent2 list-task2"')
        body.gsub!(/<h2>(.*?)<\/h2>/, '<ul class="listtype-hone listindent1 list-hone1"><li><span>\1</span></li></ul>')
      end
    end
  end
end
