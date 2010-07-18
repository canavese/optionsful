require 'lib/version'
Gem::Specification.new do |s|
  s.name = %q{optionsful}
  s.version = "#{Version.to_s}"
  s.date = %q{2010-07-15}
  s.authors = ["Marco Antonio Gonzalez Junior"]
  s.email = %q{kayaman@baurets.net}
  s.summary = %q{Optionsful provide dynamic information via HTTP's OPTION method over a Ruby on Rails applications.}
  s.homepage = %q{http://optionsful.rubyforge.org}
  s.description = %q{Optionsful provide dynamic information via HTTP's OPTION method.}
  s.add_dependency(%q<yard>, [">= 0.5"])
  
  s.files = [ "README.textile", "MIT-LICENSE", "lib/optionsful.rb", "rails/init.rb"]
end