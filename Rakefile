require 'metric_fu'
require 'rubygems'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = Dir.glob( File.dirname(__FILE__) + '/spec/**/*_spec.rb' )
  t.spec_opts << '--format specdoc'
  t.rcov = true
end

task :default => :spec
