require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "optionsful"
    gem.summary = %Q{Support HTTP OPTIONS verb on your Rails 3 app.}
    gem.description = %Q{Build RESTful web services supporting the HTTP OPTIONS verb on Ruby on Rails applications.}
    gem.email = "kayaman@baurets.net"
    gem.homepage = "http://github.com/kayaman/optionsful"
    gem.authors = ["Marco Antonio Gonzalez Junior"]
    gem.rubyforge_project = "optionsful"
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "yard", ">= 0"
    gem.add_development_dependency "cucumber", ">= 0"
    gem.add_dependency "rails", "= 3.0.0.rc2"
  end
  Jeweler::GemcutterTasks.new
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "yardoc"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_opts << '--color --format specdoc'
  spec.verbose = true
  spec.warning = false
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)

  task :features => :check_dependencies
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end

