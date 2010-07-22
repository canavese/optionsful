require File.join(File.dirname(__FILE__), 'introspections.rb')


class Optionsful  

  
  def initialize(app)  
    @app = app
    @doc = {:controller => nil, :actions => [] } # { :action => "index", :method => "GET" }, { :action => "create", :method => "POST" }
  end  

  def call(env) 
    unless env["REQUEST_METHOD"] == "OPTIONS"
      @app.call(env)
    else
      extract_options_information(env)
    end
  end

  private

  def extract_options_information(env)
    [204, {"Allow" => extract_allowed_methods(env), "Link" => build_help_link(env)}, ""]  
  end

  def extract_allowed_methods(env)
    # do routing introspection:
    routes = Introspections.do_routing_introspection
    # do request path investigation
    route_guess = Introspections.guess_route(routes, env["PATH_INFO"])
    # do the matches:
    allow = do_the_matches(routes, route_guess)
  end

  private

  def do_the_matches(routes, route_guess)
    allow = ""
    routes.each do |route|
      if route.first == route_guess
        allow += route[1].to_s.upcase! + "|" 
        @doc[:controller] = route[2][:controller]
        @doc[:actions] << { :action => (route[2][:action]), :method => (route[1].to_s.upcase!) }
      end
    end
    allow = allow.split("|").join(", ")
  end

  def build_help_link(env)
    server_name = env["SERVER_NAME"]
    server_port = env["SERVER_PORT"]
    methodz = ""
    @doc[:actions].each {|info| methodz << info[:method] + " " }
    methodz = methodz.split(" ").join(";")
    "<http://#{server_name}:#{server_port}/opts/#{@doc[:controller]}/#{methodz}>; type=text/html; rel=help"
  end



end