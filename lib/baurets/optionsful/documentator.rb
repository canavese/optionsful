module Baurets
  module Optionsful
    class Documentator

      def initialize(app)  
        @app = app
        @config = ::Baurets::Optionsful::Config.new
      end  

      def call(env) 
        unless env["PATH_INFO"].index(@config.base_path) == 0
          @app.call(env)
        else
          begin
            return extract_documentation(env)
          rescue => e
            [500, {}, e.backtrace.join("\n")]
          end
        end
      end

      private

      require 'rubygems'
      require 'yaml'
      require 'RedCloth'

      def extract_documentation(env)
        path = env["PATH_INFO"]
        path = path.gsub(@config.base_path, '')
        # do routing introspection:
        routes = ::Baurets::Optionsful::Introspections.do_routing_introspection
        # do request path investigation
        route_guess = ::Baurets::Optionsful::Introspections.guess_route(routes,path)
        # do the matches:
        allow = ::Baurets::Optionsful::Introspections.do_the_matches(routes, route_guess)
        http_methods = allow.split(", ")

        path_parts = ::Baurets::Optionsful::Introspections.prepare_request_path(path)

        controller_actions = []
        http_methods.each do |verb|
          controller_actions << [verb, relate_action_to_method(path_parts, verb)]
        end
        controller_actions.delete_if {|pair| pair[1].empty? }

        controller_name = ::Baurets::Optionsful::Introspections.discover_controller_name(path_parts) + "_controller"
        file = File.join(RAILS_ROOT, "app", "controllers", controller_name + ".rb")
        controller_class = controller_name.camelize

        service_doc = extract_comments_above(file, find_line_for(file, controller_class, :class))

        methods_docs = []
        controller_actions.each do |info|
          methods_docs << [info, extract_comments_above(file, find_line_for(file, info[1], :method)).join("\n")]
        end

        body = build_html(service_doc, methods_docs)

        [200, {"Content-Type" => "text/html"},  body]
      end


      def build_html(comment, methods)
        comments = comment.join("\n").gsub(/^#+\s/, '')
        resource = YAML::parse(comments)
        html = "<html><head></head><body>"
        resource_title = resource["resource"]["title"].value

        title = "h1. " + resource_title.to_s if resource_title

        html += RedCloth.new(title).to_html
        
        html += RedCloth.new("#{resource["resource"]["description"].value}").to_html

        methods.each do |meth|
          meth_verb = meth[0][0]
          #TODO
          html += RedCloth.new("*" + meth_verb).to_html
        end
        html += "</body></html>"
        html
      end

      def relate_action_to_method(path, verb)
        action = ""
        routes = ::Baurets::Optionsful::Introspections.do_routing_introspection
        route_guess = ::Baurets::Optionsful::Introspections.guess_route(routes, path)
        routes.each do |route|
          if ((route.first == route_guess) && (route[1][0] == verb))
            action = route[1][1] unless route[1][1].empty?
          end
        end
        action
      end

      def file_lines(file_name)
        lines = []
        begin
          file = File.new(file_name, "r")
          while (line = file.gets)
            line = line.strip
            lines << line unless line.empty?
          end
          file.close
        rescue => err
          puts "Exception: #{err}"
          err
        end
        lines.delete(nil)
        lines
      end  

      def extract_comments_above(file_name, line_number)
        lines = file_lines(file_name)
        doc = []
        line_number = line_number -1
        while ((line_number = line_number -1) && (line_number >= 0) && (!lines.nil?) && (!lines[line_number].empty?))
          line = lines[line_number].lstrip
          if line[0] == 35
            doc << line
          else
            line_number = 0
          end 
        end
        doc = doc.reverse
        doc
      end

      def find_line_for(file, name, type) 
        lines = file_lines(file)
        signature = ""
        if type == :class
          signature = "class " + name
        elsif type == :method
          signature = "def " + name
        end
        counter = 1;
        lines.each do |line|
          if line.include? signature
            return counter
          end
          counter += 1
        end
        counter = 0
      end
    end

  end
end
