require File.dirname(__FILE__) + '/spec_helper'


describe Baurets::Optionsful::Documentator do

  include Rack::Test::Methods

config = ::Baurets::Optionsful::Config.new
  path = config.base_path

  describe "as a Rack middleware" do

    it "is a Ruby object that responds to call;" do
      assert ::Baurets::Optionsful::Documentator.new(app).respond_to? :call
    end

    it "takes exactly one argument, (the environment) and returns an Array;" do
      response = ::Baurets::Optionsful::Documentator.new(app).call(mock_env({"REQUEST_METHOD" => "GET", "PATH_INFO" => path}))
      assert response.kind_of?(Array)
    end

    it "the returned Array must have exactly three values: the status, the headers and the body;" do
      response = ::Baurets::Optionsful::Documentator.new(app).call(mock_env({"REQUEST_METHOD" => "GET", "PATH_INFO" => path}))
      assert response.size.should == 3
      assert response[0].kind_of? Fixnum 
      assert response[1].kind_of? Hash
      assert response[2].kind_of? String
    end

    it "must be nice, acting somewhere on a Rack middleware stack." do
      response = fake_docs_app.call(mock_env({"REQUEST_METHOD" => "GET", "PATH_INFO" => "/lobster"}))
      assert response.size.should == 3
      assert response[0].kind_of? Fixnum
      assert response[0].should == 200
      assert response[1].kind_of? Hash
    end

  end

end