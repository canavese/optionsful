require 'rubygems'
require 'rails'

class FakeApp < Rails::Application
  
  Rails.env = "test"

end
