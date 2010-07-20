require File.dirname(__FILE__) + '/lib/baurets/optionsful/version.rb'


Gem::Specification.new do |s|
  s.name = %q{optionsful}
  s.version = "#{::Baurets::Optionsful::Version}"
  s.date = %q{2010-07-19}
  s.authors = ["Marco Antonio Gonzalez Junior"]
  s.email = %q{kayaman@baurets.net}
  s.summary = %q{Optionsful provide dynamic information via HTTP's OPTION method over a Ruby on Rails applications.}
  s.homepage = %q{http://optionsful.rubyforge.org}
  s.description = %q{Optionsful provide dynamic information via HTTP's OPTION method.}
  s.files = [ "README.textile", "MIT-LICENSE", "lib/baurets/optionsful.rb", "rails/init.rb", 
              "lib/tasks/optionsful.rake", "Rakefile", "spec/optionsful_spec.rb", "spec/spec.opts", 
              "spec/spec_helper.rb"
            ]
end