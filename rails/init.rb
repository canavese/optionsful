# Adding Optionsful to the Rack middleware stack:
ActionController::Dispatcher.middleware.use Baurets::Optionsful::Server
ActionController::Dispatcher.middleware.use Baurets::Optionsful::Documentator