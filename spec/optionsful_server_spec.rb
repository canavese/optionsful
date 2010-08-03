require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
include Rack::Test::Methods

describe "Optionsful" do

  context "as a Rack middleware" do

    it "is a Ruby object that responds to call" do
      ::Baurets::Optionsful::Server.new(app).respond_to?(:call).should be true
    end

    it "takes exactly one argument, (the environment) and returns an Array" do
      response = ::Baurets::Optionsful::Server.new(app).call(mock_env({"REQUEST_METHOD" => "OPTIONS", "PATH_INFO" => "/posts"}))
      response.should be_a_kind_of Array
    end

    it "the returned Array must have exactly three values: the status, the headers and the body" do
      response = ::Baurets::Optionsful::Server.new(app).call(mock_env({"REQUEST_METHOD" => "OPTIONS", "PATH_INFO" => "/posts"}))
      validate_response(response)
    end

    before do
      rails_app.routes.draw do
        resources :posts
      end
    end

    it "must be nice, acting somewhere on a Rack middleware stack" do
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

  context "as an HTTP OPTIONS verb provider must master Rails" do

    describe "default resources routing" do

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
      end

      it "the new action return from a GET request an HTML form for creating a new post" do
        response = http_options_request("/posts/new")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
        response[1]["Allow"].should_not include "POST"
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

      it "not finding a path, gently return 404 Not Found" do
        response = http_options_request("/sblingers/sblongers")
        validate_response(response)
        response[0].should be 404
      end


      after(:all) do
        Rails.application.reload_routes!
      end

    end

    describe "resources routing with options" do

      before(:all) do
        rails_app.routes.draw do
          resources :products do
            member do
              get :short
              post :toggle
            end
            collection do
              get :sold
            end
          end
        end
      end

      it "a GET member example should work" do
        response = http_options_request("/products/123/short")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
      end

      it "a POST member example should work" do
        response = http_options_request("/products/123/toggle")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "POST"
      end

      it "a named route with options should work" do
        response = http_options_request("/products/sold")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
      end

      after(:all) do
        Rails.application.reload_routes!
      end

    end

    describe "resources routing with sub-resources" do

      before(:all) do
        rails_app.routes.draw do
          resources :products do
            resources :sales
            resource :seller
          end
        end
      end

      it "the parent resource collection does listing and creation" do
        response = http_options_request("/products")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
        response[1]["Allow"].should include "POST"
      end

      it "the parent resource collection have an entry point for creating a new entry" do
        pending "check regexp"
        response = http_options_request("/products/new")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
        response[1]["Allow"].should_not include "POST"
        response[1]["Allow"].should_not include "PUT"
        response[1]["Allow"].should_not include "DELETE"
      end

      it "the parent resource collection have an entry point for editing an existing entry" do
        response = http_options_request("/products/123/edit")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
        response[1]["Allow"].should_not include "POST"
        response[1]["Allow"].should_not include "PUT"
        response[1]["Allow"].should_not include "DELETE"
      end

      it "the parent resource collection let its entries be read, updated and deleted" do
        response = http_options_request("/products/123")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
        response[1]["Allow"].should include "PUT"
        response[1]["Allow"].should include "DELETE"
      end

      it "the parent resource collection let its sub-resource to be created, read, updated and deleted" do
        response = http_options_request("/products/123/seller")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "POST"
        response[1]["Allow"].should include "GET"
        response[1]["Allow"].should include "PUT"
        response[1]["Allow"].should include "DELETE"
      end

      it "the parent resource collection offers its sub-resource an entry point for creating a new entry" do
        response = http_options_request("/products/123/seller/new")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
        response[1]["Allow"].should_not include "POST"
        response[1]["Allow"].should_not include "PUT"
        response[1]["Allow"].should_not include "DELETE"
      end

      it "the parent resource collection offers its sub-resource an entry point for editing the existing entry" do
        response = http_options_request("/products/123/seller/edit")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
        response[1]["Allow"].should_not include "POST"
        response[1]["Allow"].should_not include "PUT"
        response[1]["Allow"].should_not include "DELETE"
      end

      it "the sub-resource collection behaves like a common resource collection" do
        response = http_options_request("/products/123/sales")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
        response[1]["Allow"].should include "POST"
        response[1]["Allow"].should_not include "PUT"
        response[1]["Allow"].should_not include "DELETE"
      end

      it "the sub-resource collection have an entry point for creating a new entry" do
        pending "check regexp"
        response = http_options_request("/products/123/sales/new")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
        response[1]["Allow"].should_not include "POST"
        response[1]["Allow"].should_not include "PUT"
        response[1]["Allow"].should_not include "DELETE"
      end

      it "the sub-resource collection have an entry point for editing an existing entry" do
        response = http_options_request("/products/123/sales/123/edit")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
        response[1]["Allow"].should_not include "POST"
        response[1]["Allow"].should_not include "PUT"
        response[1]["Allow"].should_not include "DELETE"
      end

      it "the sub-resource collection let its entries be read, updated and deleted" do
        response = http_options_request("/products/123/sales/456")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
        response[1]["Allow"].should include "PUT"
        response[1]["Allow"].should include "DELETE"
        response[1]["Allow"].should_not include "POST"
      end

      after(:all) do
        Rails.application.reload_routes!
      end
    end

    describe "resources routing with more complex sub-resources" do

      before(:all) do
        rails_app.routes.draw do
          resources :products do
            resources :sales do
              get :recent, :on => :collection
            end
          end
        end
      end

      it "blah" do
        response = http_options_request("/products/123/sales/recent.xml")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
      end

      after(:all) do
        Rails.application.reload_routes!
      end
    end

    describe "resources routing within a namespace" do

      before(:all) do
        rails_app.routes.draw do
          namespace :admin do
            resources :products
          end
        end
      end

      it "a simple matching should work" do
        response = http_options_request("/admin/products/123")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
      end

      after(:all) do
        Rails.application.reload_routes!
      end
    end

    describe "custom regular routing" do

      before(:all) do
        rails_app.routes.draw do
          match 'products/:id' => 'catalog#view'
        end
      end

      it "a simple matching should work" do
        response = http_options_request("/products/123")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
      end

      after(:all) do
        Rails.application.reload_routes!
      end

    end

    describe "the root" do

      before(:all) do
        rails_app.routes.draw do
          root :to => "welcome#index"
        end
      end

      it " / should work" do
        response = http_options_request("/")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
      end

      after(:all) do
        Rails.application.reload_routes!
      end

    end

    describe "the legacy 'WILD' controller" do

      before(:all) do
        rails_app.routes.draw do
          match ':controller(/:action(/:id(.:format)))'
        end
      end

      it "a simple matching should work" do
        response = http_options_request("/products/show/123.json")
        validate_response(response)
        response[0].should be 204
        response[1]["Allow"].should include "GET"
      end

      after(:all) do
        Rails.application.reload_routes!
      end

    end



  end

  context "Link" do

    describe "should not be present" do

      before(:all) do
        rails_app.routes.draw do
          resources :posts
        end
      end

      it "if no directions were given" do
        response = http_options_request("/posts")
        validate_response(response)
        response[0].should be 204
        response[1]["Link"].should be nil
      end

      after(:all) do
        Rails.application.reload_routes!
      end

    end

    describe "behave arbitrarily " do
      
      before(:all) do
        rails_app.routes.draw do
          resources :posts
        end
        
        
      end

      it "if directions were given" do


      end

      it "the Link header MUST be quoted if it contains a semicolon or comma" do
        pending "link tests based on yml"
        response = http_options_request("/posts")
        validate_response(response)
        response[0].should be 204
        link = response[1]["Link"]
        link.should match /\A"{1}.+"\z/ 
      end

      after(:all) do
        Rails.application.reload_routes!
      end

    end

  end

end