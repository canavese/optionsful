

namespace :ex do
  desc "Generate example docs"
  task :generate do
    `yardoc 'app/controllers/*.rb' -t rest --backtrace -p ../yardoc_ext/templates -e ../yardoc_ext/yard-rest.rb -r README --title 'Blog API'`
  end

  desc "Clean example docs"
  task :clean do
    `rm -R doc`
    `rm -R .yardoc`
  end
  
end