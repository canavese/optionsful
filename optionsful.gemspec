require File.dirname(__FILE__) + '/lib/baurets/optionsful/version.rb'

Gem::Specification.new do |s|
  s.name = %q{optionsful}
  s.version = "#{::Baurets::Optionsful::Version}"
  s.date = %q{2010-07-22}
  s.authors = ["Marco Antonio Gonzalez Junior"]
  s.email = %q{kayaman@baurets.net}
  s.summary = %q{Optionsful provide dynamic information via HTTP's OPTION method over a Ruby on Rails applications.}
  s.homepage = %q{http://optionsful.rubyforge.org}
  s.description = %q{Optionsful provide dynamic information via HTTP's OPTION method.}
  s.files = [ "README.textile", "MIT-LICENSE", "lib/baurets/optionsful/server.rb", "rails/init.rb", 
    "lib/tasks/optionsful.rake", "Rakefile", "spec/optionsful_server_spec.rb", "spec/spec.opts", 
    "spec/spec_helper.rb", "lib/baurets/optionsful/documentator.rb", "lib/baurets/optionsful/introspections.rb", 
    "lib/baurets/optionsful/version.rb","lib/baurets/optionsful/config.rb", "lib/optionsful.rb", "spec/optionsful_documentator_spec.rb"
  ]

end