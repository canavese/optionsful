require File.join(File.dirname(__FILE__), '..', 'lib','optionsful.rb')
require File.join(File.dirname(__FILE__), '..', 'lib','optionsful_docs.rb')

require 'rubygems' 
require 'sinatra' 
require 'rack/test' 
require 'rack' 
require 'rack/lobster' 
require 'spec'
require 'spec/autorun' 
require 'spec/interop/test' 
require 'action_controller' 


# set test environment set :environment, :test set :run, false set :raise_errors, true set :logging, false

DEFAULT_ENV = { "rack.version" => Rack::VERSION, "rack.input" => StringIO.new, "rack.errors" => StringIO.new,
  "rack.multithread" => true, "rack.multiprocess" => true, "rack.run_once" => false, }

  SAMPLE_ENV = {"rack.session"=>{:session_id=>"f66c8af1e89f318775e923159e046e71"}, "SERVER_NAME"=>"localhost",
  "HTTP_HOST"=>"localhost:3332", "REMOTE_HOST"=>"localhost", "HTTP_USER_AGENT"=>"HTTP%20Client0.9.1
  CFNetwork/438.14 Darwin/9.8.0 (i386) (MacBook4%2C1)", "rack.url_scheme"=>"http", "REQUEST_PATH"=>"/",
  "SERVER_PROTOCOL"=>"HTTP/1.1", "rack.errors"=>"", "PATH_INFO"=>"/", "REMOTE_ADDR"=>"127.0.0.1",
  "SERVER_SOFTWARE"=>"WEBrick/1.3.1 (Ruby/1.8.7/2010-06-23)", "rack.run_once"=>false, "rack.version"=>[1, 1],
  "SCRIPT_NAME"=>"", "rack.multithread"=>false, "HTTP_VERSION"=>"HTTP/1.1", "REQUEST_URI"=>"",
  "rack.multiprocess"=>false, "SERVER_PORT"=>"3332", "rack.session.options"=>{:domain=>"nilly", :path=>"/",
    :key=>"_session_id", :httponly=>true, :expire_after=>300, :id=>"f66c8af1e89f318775e923159e046e71"},
    "REQUEST_METHOD"=>"HEAD", "GATEWAY_INTERFACE"=>"CGI/1.1", "QUERY_STRING"=>"", "HTTP_CONNECTION"=>"close"}

    FAKE_ENV = SAMPLE_ENV.merge!(DEFAULT_ENV)

    def app
      app = Rack::Builder.new {
        use Rack::CommonLogger
        use Rack::ShowExceptions
      } 
    end


    def fake_opts_app
      app = Rack::Builder.new {
        use Rack::CommonLogger
        use Rack::ShowExceptions
        use Optionsful
        map "/lobster" do
          use Rack::Lint
          run Rack::Lobster.new
        end
      }
    end
    
    def fake_docs_app
      app = Rack::Builder.new {
        use Rack::CommonLogger
        use Rack::ShowExceptions
        use OptionsfulDocs
        map "/lobster" do
          use Rack::Lint
          run Rack::Lobster.new
        end
      }
    end

    def mock_env(options = {})
      FAKE_ENV.merge!(options)
    end

    def http_options_request(path)
      complex_env = mock_env({"REQUEST_METHOD" => "OPTIONS", "PATH_INFO" => path })
      response = Optionsful.new(app).call(complex_env)
    end
    
    def allows?(headers, method)
      headers["Allow"].include?(method)
    end
      


