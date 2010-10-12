$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib', 'baurets'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib', 'baurets', 'optionsful'))
require 'optionsful'
require 'server'
require 'introspections'

require 'rspec'

require 'fake_app'
require 'rubygems'

require 'rails'
require 'rack' 
require 'rack/test'
require 'rack/lobster' 
require 'fileutils'

RSpec.configure do |config|

end

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
        use Baurets::Optionsful::Server
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
      response = Baurets::Optionsful::Server.new(app).call(complex_env)
    end

    def allows?(headers, method)
      headers["Allow"].include?(method)
    end
    
    def validate_response(response)
      response.should be_a_kind_of Array
      response.size.should == 3
      response[0].should be_a_kind_of Fixnum 
      response[1].should be_a_kind_of Hash
      response[2].should_not be nil
    end
    
    def rails_app 
      app = FakeApp.initialize!
      app
    end
    
    def configuration
      configurator = Baurets::Optionsful::Configurator.new
      configuration = configurator.configure!
      configuration
    end
    
    def delete_configuration_file
      FileUtils.rm [File.join(Rails.root, 'config', 'optionsful.yml')] if File.exist? File.join(Rails.root, 'config', 'optionsful.yml')
    end
    
    def backup_configuration_file
      FileUtils.cp File.join(Rails.root, 'config', 'optionsful.yml'), File.join(Rails.root, 'config', 'optionsful.yml.tmp') if File.exist? File.join(Rails.root, 'config', 'optionsful.yml')
      FileUtils.rm [File.join(Rails.root, 'config', 'optionsful.yml')] 
    end
    
    def restore_configuration_file
      FileUtils.cp File.join(Rails.root, 'config', 'optionsful.yml.tmp'), File.join(Rails.root, 'config', 'optionsful.yml') if File.exist? File.join(Rails.root, 'config', 'optionsful.yml.tmp')
      FileUtils.rm [File.join(Rails.root, 'config', 'optionsful.yml.tmp')] if File.exist? File.join(Rails.root, 'config', 'optionsful.yml.tmp')
    end
    
    def copy_configuration_file(name)
      FileUtils.cp File.join(Rails.root, 'samples', name), File.join(Rails.root, 'config', 'optionsful.yml')
    end
    
    def simulate_rake_yml_task
      FileUtils.cp File.join(Rails.root, 'samples', 'optionsful.yml'), File.join(Rails.root, 'config', 'optionsful.yml')      
    end
