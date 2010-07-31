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
    
    before do
      rails_app.routes.draw do
        resources :posts
      end
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
        rails_app.routes.draw do
          resources :posts
        end
      end

      it "the index action displays a list of all posts in response of a GET request" do
        response = http_options_request("/posts")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
        response[1]["Allow"].should include "POST"
      end

      it "the index action displays a list of all posts in response of a GET request" do
        response = http_options_request("/posts")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
      end

      it "the new action return from a GET request an HTML form for creating a new post" do
        response = http_options_request("/posts/new")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
      end

      it "the create action uses POST to create a new post instance" do
        response = http_options_request("/posts")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "POST"
      end

      it "the show action display a specific post in response of a GET request" do
        response = http_options_request("/posts/1")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
      end

      it "the edit action return an HTML form for editing a post in response of a GET request" do
        response = http_options_request("/posts/1/edit")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
      end

      it "the update action uses PUT to update a specific post" do
        response = http_options_request("/posts/1")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "PUT"
      end

      it "the destroy action uses DELETE to delete a specific post" do
        response = http_options_request("/posts/1")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "DELETE"
      end 

      it "not finding a path, return 404 Not Found" do
        response = http_options_request("/sblingers/sblongers")
        validate_response(response)
        response[0].should be 404
      end

      it "the Link header MUST be quoted if it contains a semicolon or comma" do
        response = http_options_request("/posts")
        validate_response(response)
        response[0].should be 204
        link = response[1]["Link"]
        link.should match /\A"{1}.+"\z/ 
      end

    end
  end

end

