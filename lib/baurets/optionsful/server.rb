module Baurets
  module Optionsful
    class Server

      def initialize(app)  
        @app = app
        @config = Config.new
      end  

      def call(env) 
        unless env["REQUEST_METHOD"] == "OPTIONS"
          @app.call(env)
        else
          @env = env
          build_response
        end
      end

      private

      def build_response
        allows = extract_options_information
        headers = {}
        status = 500
        body = ""
        unless allows.empty?
          headers.merge!({"Allow" => allows})
          status = 204
          if @config.link
            link = ""


            headers.merge!({"Link" => link})
          end
        else
          status = 404
          body = "Not found"
        end
        [status, headers, body]
      end

      def extract_options_information
        allows = ::Baurets::Optionsful::Introspections.do_the_matches(@env["PATH_INFO"])
      end

    end
  end
end

