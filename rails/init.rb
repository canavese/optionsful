# Adding Optionsful to the Rack middleware stack:
ActionController::Dispatcher.middleware.use "Optionsful"

puts "\n\nINIT:"
ActionController::Routing::Routes.add_route("/help", {:controller => "help", :action => "index"})