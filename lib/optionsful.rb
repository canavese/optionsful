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
    routes = do_routing_introspection
    # do request path investigation
    route_guess = guess_route(routes, env["PATH_INFO"])
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

  def guess_route(routes, path)
    parts = prepare_request_path(path)
    guess = []
    index = 0
    parts.each do |part|
      if is_part_static?(routes, index, part)
        guess << part
      else
        guess << :dynamic
      end
      index += 1
    end
    guess
  end

  def is_part_static?(routes, index, value)
    routes.each do |route|
      if route[0][index] == value
        return true
      end
    end
    return false
  end

  def do_routing_introspection
    routes = []
    route_requirements = nil
    ActionController::Routing::Routes.routes.each do |route|
      static_path = []
      route.segments.each do |segment|
        route_requirements = route.requirements #TODO validate 
        if segment.kind_of?(ActionController::Routing::StaticSegment)
          static_path << segment.value if (segment.respond_to?(:value) && segment.value != "/")
        elsif segment.kind_of?(ActionController::Routing::DynamicSegment)
          static_path << :dynamic unless (segment.respond_to?(:key) && segment.key == :format)   
        end
      end
      routes << [static_path, route.conditions[:method], route_requirements] unless route.conditions[:method].nil?
    end
    routes
  end

  def prepare_request_path(path)
    path = path[0..(path.rindex('.')-1)] if path.include?('.')
    path_parts = path.split("/")
    path_parts.delete("")
    path_parts
  end

end