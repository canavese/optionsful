module Baurets
  module Optionsful
    class Server

      def initialize(app)  
        @app = app
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
        allows = ::Baurets::Optionsful::Introspections.do_the_matches(env["PATH_INFO"])
        unless allows.empty?
          [204, {"Allow" => allows, "Link" => "\"<http://under.development.net\""}, ""]  
        else
          [404, {}, "Not found"]
        end
      end

    end
  end
end

