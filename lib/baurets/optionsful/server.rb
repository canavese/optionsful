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
          [204, {"Allow" => %Q{Under development...}, "Link" => "\"<http://under.development.net\""}, ""]  
      end

    end
  end
end

