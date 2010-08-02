require 'fileutils'

namespace :optionsful do
  desc "Install 'config/optionsful.yml'"
  task :yml do
    puts File.dirname(__FILE__)
  end
end