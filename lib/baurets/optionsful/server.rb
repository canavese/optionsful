module Baurets
  module Optionsful
    class Server

      def initialize(app)  
        @app = app
        @config = ::Baurets::Optionsful::Config.new
      end  

      def call(env) 
        unless env["REQUEST_METHOD"] == "OPTIONS"
          @app.call(env)
        else
          extract_options_information(env)
        end
      end

      private

      def extract_options_information(env)
        allows = extract_allowed_methods(env)
        if allows.empty?
          [404, {}, "Not found."] 
        else
          [204, {"Allow" => allows, "Link" => build_help_link(env)}, ""]  
        end
      end

      def extract_allowed_methods(env)
        # do routing introspection:
        routes = ::Baurets::Optionsful::Introspections.do_routing_introspection
        # do request path investigation
        path = env["PATH_INFO"]
        route_guess = ::Baurets::Optionsful::Introspections.guess_route(routes, path)
        # do the matches:
        allow = ::Baurets::Optionsful::Introspections.do_the_matches(routes, route_guess)
      end

      def build_help_link(env)
        server_name = env["SERVER_NAME"]
        server_port = env["SERVER_PORT"]
        "<http://#{server_name}:#{server_port}" + @config.base_path + "#{env["PATH_INFO"]}>; type=text/html; rel=help"
      end

    end
  end
end