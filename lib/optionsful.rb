##
# Baurets Software
# kayaman@baurets.net
#
module Baurets
  module Optionsful
    autoload :Server, 'baurets/optionsful/server'
    autoload :Introspections, 'baurets/optionsful/introspections'
    autoload :Configurator, 'baurets/optionsful/configurator'
    
    LIB_ROOT = File.dirname(__FILE__)
  end
end


require 'rubygems'
require 'rake'
unless Rake::Task.task_defined? "optionsful:yml"
  load File.join(Baurets::Optionsful::LIB_ROOT, '..', 'tasks', 'optionsful.rake')
end