require File.dirname(__FILE__) + '/spec_helper'
# require 'ruby-debug'

describe "Optionsful" do
  include Rack::Test::Methods

  def app
    @app ||= Rack::Builder.new {
      use Rack::CommonLogger
      use Rack::ShowExceptions
    } 
  end

  def mock_env(options = {})
    env = options
  end
  
  def env
    {"rack.session"=>{:session_id=>"f66c8af1e89f318775e923159e046e71"}, 
    "SERVER_NAME"=>"localhost", "HTTP_HOST"=>"localhost:3332", "REMOTE_HOST"=>"localhost",
     "HTTP_USER_AGENT"=>"HTTP%20Client0.9.1 CFNetwork/438.14 Darwin/9.8.0 (i386) (MacBook4%2C1)", 
     "rack.url_scheme"=>"http", "REQUEST_PATH"=>"/", "SERVER_PROTOCOL"=>"HTTP/1.1", "rack.errors"=>"", 
     "PATH_INFO"=>"/", "REMOTE_ADDR"=>"127.0.0.1", "SERVER_SOFTWARE"=>"WEBrick/1.3.1 (Ruby/1.8.7/2010-06-23)", 
     "rack.run_once"=>false, "rack.version"=>[1, 1], "SCRIPT_NAME"=>"", "rack.multithread"=>false, 
     "HTTP_VERSION"=>"HTTP/1.1", "REQUEST_URI"=>"", "rack.multiprocess"=>false, "SERVER_PORT"=>"3332", "rack.session.options"=>{:domain=>nil, :path=>"/", :key=>"_session_id", :httponly=>true, :expire_after=>nil, :id=>"f66c8af1e89f318775e923159e046e71"}, "REQUEST_METHOD"=>"HEAD", "GATEWAY_INTERFACE"=>"CGI/1.1", "QUERY_STRING"=>"", "HTTP_CONNECTION"=>"close", "rack.input"=> ""}
  end

  before(:all) do
    ActionController::Routing::Routes.draw do |map| 
      map.resources :posts, :has_many => :comments
    end
  end

  after(:all) do
    ActionController::Routing::Routes.reload!
  end

  # A Rack application is an Ruby object (not a class) that responds to call. It takes exactly one argument, the
  # environment and returns an Array of exactly three values: The status, the headers, and the body.

  describe "as a Rack application," do

    it "is an Ruby object that responds to call" do
      assert Optionsful.new(app).respond_to?(:call)
    end

    it "takes exactly one argument, (the environment) and returns an Array" do
      assert Optionsful.new(app).call(mock_env({"REQUEST_METHOD" => "OPTIONS", "PATH_INFO" => "/" })).kind_of?(Array)
    end

    it "returns an Array of exactly three values: The status, the headers, and the body" do
      response = Optionsful.new(app).call(mock_env({"REQUEST_METHOD" => "OPTIONS", "PATH_INFO" => "/" }))
      assert response.size.should == 3
    end
  end

  describe " path info recognition " do 

    it "recognize route for single static path part" do
      assert Optionsful.new(app).call(mock_env({"REQUEST_METHOD" => "OPTIONS", "PATH_INFO" => "/posts" })).kind_of?(Array)
    end

    it "recognize route for one static path parts and one dynamic" do
      assert Optionsful.new(app).call(mock_env({"REQUEST_METHOD" => "OPTIONS", "PATH_INFO" => "/posts/1" })).kind_of?(Array)
    end

    it "recognize route for 2 static path parts and 1 dynamic" do
      assert Optionsful.new(app).call(mock_env({"REQUEST_METHOD" => "OPTIONS", "PATH_INFO" => "/posts/1/comments" })).kind_of?(Array)
    end

    it "recognize route for 2 static path parts and 2 dynamic" do
      assert Optionsful.new(app).call(mock_env({"REQUEST_METHOD" => "OPTIONS", "PATH_INFO" => "/posts/1/comments/1" })).kind_of?(Array)
    end

  end

  describe " dispatch the call to the application unless HTTP method equals OPTIONS " do

    it " method GET example" do
      response = Optionsful.new(app).call(env)
      assert response.size.should == 3
    end

  end

end
