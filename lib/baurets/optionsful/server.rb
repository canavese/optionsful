module Baurets
  module Optionsful
    class Server
      include Baurets::Optionsful::Introspections

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
        routing_introspection
        [204, {"Allow" => %Q{GET}, "Link" => "\"<http://under.development.net\""}, ""]  
      end

    end
  end
end

