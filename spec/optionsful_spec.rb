require File.dirname(__FILE__) + '/spec_helper'


describe "Baurets::Optionsful," do

  include Rack::Test::Methods

  before(:all) do
    ActionController::Routing::Routes.draw do |map| 
      map.resources :posts, :has_many => :comments
    end
  end


  describe "as a Rack middleware" do

    it "is a Ruby object that responds to call;" do
      assert Baurets::Optionsful.new(app).respond_to? :call
    end

    it "takes exactly one argument, (the environment) and returns an Array;" do
      response = Baurets::Optionsful.new(app).call(mock_env({"REQUEST_METHOD" => "OPTIONS", "PATH_INFO" => "/posts"}))
      assert response.kind_of?(Array)
    end

    it "the returned Array must have exactly three values: the status, the headers and the body;" do
      response = Baurets::Optionsful.new(app).call(mock_env({"REQUEST_METHOD" => "OPTIONS", "PATH_INFO" => "/posts"}))
      assert response.size.should == 3
      assert response[0].kind_of? Fixnum 
      assert response[1].kind_of? Hash
      assert response[2].kind_of? String
    end
    
    it "must be nice, somewhere on a Rack middleware stack." do
      response = fake_app.call(mock_env({"REQUEST_METHOD" => "OPTIONS", "PATH_INFO" => "/posts"}))
      assert response.size.should == 3
      assert response[0].kind_of? Fixnum
      assert response[0].should == 204
      assert response[1].kind_of? Hash
      assert response[1]["Allow"]
      # assert response[1]["Allow"].should_not be_nil
    end

  end


  describe "to collect the allowed HTTP methods" do

    describe "overrides Rails routing recognition " do 

      describe "must understand the default Rails resource routing: " do

        it "the index action displays a list of all posts in response of a GET request;" do
          response = http_options_request("/posts")
          assert response.kind_of?(Array)
          assert response[1]["Allow"]
        end
        
        it "the new action return from a GET request an HTML form for creating a new post;" do
          response = http_options_request("/posts/new")
          assert response.kind_of?(Array)
        end
        
        it "the create action uses POST to create a new post instance;" do
          response = http_options_request("/posts")
          assert response.kind_of?(Array)
        end
        
        it "the show action display a specific post in response of a GET request;" do
          response = http_options_request("/posts/1")
          assert response.kind_of?(Array)
        end
        
        it "the edit action return an HTML form for editing a post in response of a GET request;" do
          response = http_options_request("/posts/1/edit")
          assert response.kind_of?(Array)
        end
        
        it "the update action uses PUT to update a specific post;" do
          response = http_options_request("/posts/1")
          assert response.kind_of?(Array)
        end
        
        it "the destroy action uses DELETE to delete a specific post." do
          response = http_options_request("/posts/1")
          assert response.kind_of?(Array)
        end 
        
      end
      
    end
    
  end

  describe " dispatch the call to the application unless HTTP method equals OPTIONS " do

    it " method GET example" do
      complex_env = mock_env({"REQUEST_METHOD" => "GET", "PATH_INFO" => "/lobster" })
      response = fake_app.call(complex_env)
      assert response.kind_of?(Array)
      assert response.size.should == 3
    end

  end

  after(:all) do
    ActionController::Routing::Routes.reload!
  end

end
