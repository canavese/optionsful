require File.dirname(__FILE__) + '/spec_helper'

describe "Optionsful" do
  include Rack::Test::Methods
  
  class MyMiddlewareTestController < ActionController::Base
    def index
    end
  end
  

  def app
    @app ||= Rack::Builder.new {
   #   use Rack::CommonLogger
   #   use Rack::ShowExceptions
      use Optionsful
    } 
  end
  
  before(:all) do
    ActionController::Routing::Routes.draw do |map| 
      map.connect '/test/:action', :controller => :my_middleware_test_controller
    end
  end

  after(:all) do
    ActionController::Routing::Routes.reload!
  end

  it "should respond to /" do
    get '/test/foc'
    last_response.should be_ok
  end
  
  it "should test" do
     get '/test/index'
   end
  
end
