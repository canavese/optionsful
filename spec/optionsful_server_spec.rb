require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
include Rack::Test::Methods

describe "Optionsful" do

  context "as a Rack middleware" do

    it "is a Ruby object that responds to call;" do
      ::Baurets::Optionsful::Server.new(app).respond_to?(:call).should be true
    end

    it "takes exactly one argument, (the environment) and returns an Array;" do
      response = ::Baurets::Optionsful::Server.new(app).call(mock_env({"REQUEST_METHOD" => "OPTIONS", "PATH_INFO" => "/posts"}))
      response.should be_a_kind_of Array
    end

    it "the returned Array must have exactly three values: the status, the headers and the body;" do
      response = ::Baurets::Optionsful::Server.new(app).call(mock_env({"REQUEST_METHOD" => "OPTIONS", "PATH_INFO" => "/posts"}))
      validate_response(response)
    end

    it "must be nice, acting somewhere on a Rack middleware stack;" do
      response = fake_opts_app.call(mock_env({"REQUEST_METHOD" => "OPTIONS", "PATH_INFO" => "/posts"}))
      validate_response(response)
      response[0].should be 204
      response[1]["Allow"].should_not be nil
    end

    it "must let the request go through the stack, if it has nothing to it!" do
      response = fake_opts_app.call(mock_env({"REQUEST_METHOD" => "GET", "PATH_INFO" => "/lobster"}))
      validate_response(response)
      response[0].should be 200
    end

  end

  context "as an HTTP OPTIONS verb provider" do

    describe "must recognize the Rails resources routing" do

      before(:all) do
        rails_app.routes do
          resources :posts
        end
      end

      it "the index action displays a list of all posts in response of a GET request" do
        response = http_options_request("/posts")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
      end

    end
  end

end

