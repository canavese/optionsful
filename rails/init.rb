# Adding Optionsful to the Rack middleware stack:
ActionController::Dispatcher.middleware.use "Optionsful"

puts "\n\nINIT: v0.2.0 -"

# ActionController::Routing::Routes.draw do |map|
#   
#   map.connect 'help/:id', :controller => 'help', :action => 'index', :id => /(\w+)/
#   # map.help 'help/:name', :controller => 'help', :action => 'index'
#   
# end
# ActionController::Routing::Routes.add_named_route("help/:id", {:controller => "help", :action => "index", :id => /(\w+)/})

# puts ActionController::Routing::Routes.routes.size
# puts ActionController::Routing::Routes.routes.inspect
# puts ActionController::Routing::Routes.routes.class
# 
# ActionController::Routing::Routes.add_route("/help", {:controller => "help", :action => "index"})
# 
# puts ActionController::Routing::Routes.routes.size