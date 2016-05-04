module Hackpad
  module Migration
    class Migrator
      attr_reader :db
      def initialize(db)
        @db = db
      end

      def migrate_with(source)
        pad_list = source.list
        exit_if_error(pad_list, 'Get error when fetching pad list from source site')
        pad_list.each do |source_pid|
          body = fix_body(source, source_pid, source.get(source_pid))
          unless body[/You'll need to turn on JavaScript to use Hackpad in all of its/].nil?
            puts "WARNING: the pad from source #{source_pid} seems not found."
          end
          target_pid = db.source_and_target_map[source_pid]
          if target_pid.nil?
            pad = db.target.create(body)
            # pad {"padId"=>"RAtutOXxMGF1", "globalPadId"=>"2$RAtutOXxMGF1"}
            db.add_source_and_target(source_pid, pad['padId'])
            puts "created pad #{pad['padId']} from source pad #{source_pid}"
          else
            puts "Updating pad #{target_pid} from source pad #{source_pid}"
            pad = db.target.update(target_pid, body)
            exit_if_error(pad, 'Got error when update pad for target site')
          end
          db.write!
        end
      end

      def migrate
        db.each_source do |source|
          migrate_with(source)
        end
      end

      private
      def fix_body(source, pid, body)
        html_doc = Nokogiri::HTML(body)
        fix_data_missing(body)
        h1 = html_doc.at_css('h1:first')
        head_text = ''
        if h1
          head_text = h1.text
          # override origin head
          origin_link = "<div>NOTE: This pad is migrated from #{source.client.uri}, <a href=\"#{source.client.uri}/#{pid}\">here is original pad</a></div>"
          h1.inner_html = origin_link
        end
        body = html_doc.at_css('body')
        begin
          [head_text, body ? body.inner_html : ''].join("\n")
        rescue Exception => e
          puts "Got error with pid #{pid}: " + e.message
          body
        end
      end

      def fix_data_missing(body)
        body.gsub!('class="taskdone"', 'class="listtype-taskdone listindent2 list-taskdone2"')
        body.gsub!('class="task"', 'class="listtype-task listindent2 list-task2"')
        body.gsub!(/<h2>(.*?)<\/h2>/, '<ul class="listtype-hone listindent1 list-hone1"><li><span>\1</span></li></ul>')
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
