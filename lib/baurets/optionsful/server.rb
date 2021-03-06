module Baurets
  module Optionsful
    class Server

      ## 
      # Wakes up!
      #
      def initialize(app)  
        @app = app
        @config = Configurator.new.configure!
      end  

      ##
      # Handle HTTP OPTIONS requests.
      # 
      def call(env) 
        unless env["REQUEST_METHOD"] == "OPTIONS"
          @app.call(env)
        else
          @env = env
          build_response
        end
      end

      private
      
      def extract_options_information
        allows = ::Baurets::Optionsful::Introspections.do_the_matches(@env["PATH_INFO"])
      end

      def build_response
        allows = extract_options_information
        headers = {}
        status = 500
        body = ""
        unless allows.empty?
          headers.merge!({"Allow" => allows})
          status = 204
          if @config[:link] == true
            headers.merge!({"Link" => build_link_header})
          end
          headers.merge!("Access-Control-Allow-Methods" => [allows, 'OPTIONS'].join(", "),
                         "Access-Control-Max-Age" => '1728000')
          if origin = @env['HTTP_ORIGIN']
            headers.merge!("Access-Control-Allow-Origin" => origin)
          end
          if request_headers = @env['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']
            headers.merge!("Access-Control-Allow-Headers" => request_headers)
          end
          if access_control_host = @config[:access_control_host]
            headers.merge!("Access-Control" => "allow <#{access_control_host}>")
          end
          headers.merge!("Access-Control-Allow-Credentials" => 'true')
        else
          status = 404
          body = "Not found."
        end
        [status, headers, body]
      end
      
      def build_link_header
        link = ""
        if @config[:host] == "auto"
          server_name = @env["SERVER_NAME"]
          server_port = @env["SERVER_PORT"]
          link = "\"<http://#{server_name}:#{server_port}"
        else
          link = "\"<http://#{@config[:host]}"
        end
        unless @config[:base_path].empty?
          link += @config[:base_path] unless @config[:base_path] == "/"
        end
        if @config[:propagate] == true
          link += @env["PATH_INFO"]
        end
        link += ">; type=text/html; rel=help\""
        link
      end

    end
  end
end

