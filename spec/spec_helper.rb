require File.join(File.dirname(__FILE__), '..', 'lib','optionsful.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rack'
require 'spec'
require 'spec/autorun'
require 'spec/interop/test'
require 'action_controller'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false
