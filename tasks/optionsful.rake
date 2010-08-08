require 'fileutils'
require 'rake'

namespace :optionsful do
  desc "Enable Optionsful custom configurations by creating the file 'config/optionsful.yml'"
  task :yml do
    FileUtils.cp File.join(Baurets::Optionsful::LIB_ROOT, '..','samples', 'optionsful.yml'), File.join(Rails.root, 'config', 'optionsful.yml')
    puts "\nNow you are able to configure Optionsful Link hader generation settings"
    puts "\nEdit the file 'config/optionsful.yml' at your Rails 3 application."
  end
end