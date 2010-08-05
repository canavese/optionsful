require 'rubygems'
require 'rake'


##
# Baurets Software
# kayaman@baurets.net
#
module Baurets
  module Optionsful
    autoload :Server, 'baurets/optionsful/server'
    autoload :Introspections, 'baurets/optionsful/introspections'
    autoload :Config, 'baurets/optionsful/config'
    
    LIB_ROOT = File.dirname(__FILE__)
  end
end

unless Rake::Task.task_defined? "optionsful:yml"
  load File.join(Baurets::Optionsful::LIB_ROOT, '..', 'tasks', 'optionsful.rake')
end