require 'fileutils'
require 'rake'

namespace :optionsful do
  desc "Install 'config/optionsful.yml'"
  task :yml do
    FileUtils.cp File.join(Baurets::Optionsful::LIB_ROOT, '..','config', 'optionsful.yml'), File.join(Rails.root, 'config', 'optionsful.yml')
    puts "\nNow you are able to configure Link hader generation settings"
    puts "\nEdit the file 'config/optionsful.yml' on your Rails application."
  end
end