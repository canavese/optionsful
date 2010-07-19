class Optionsful  

  def initialize(app)  
    @app = app  
  end  

  def call(env) 
    if is_help_extras_enabled?(env["PATH_INFO"])
       [303, {"Location" => build_location_uri(env), "Content-Type" => "text/html"}, "<html><body>Please go to <h1><a href='#{build_location_uri(env)}'>#{build_location_uri(env)}</a></h1></body></html>"]
    else
      unless env["REQUEST_METHOD"] == "OPTIONS"
        @app.call(env)
      else
        extract_options_information(env)
      end
    end
  end

  private

  def extract_options_information(env)
      [204, {"Allow" => extract_allowed_methods(env), "Link" => build_help_link}, ""]
  end

  def extract_allowed_methods(env)
    # do routing introspection:
    routes = do_routing_introspection
    # do request path investigation
    route_guess = guess_route(routes, env["PATH_INFO"])
    allows = ""
    # do the matches:
    routes.each do |route|
      if route.first == route_guess
        allows += route[1].to_s.upcase! + "|" 
      end
    end
    allows = allows.split("|").join(", ")
  end

  def build_help_link
    #PENDING
    "<http://baurets.net/api/resources>; type=text/html; rel=help"
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
    ActionController::Routing::Routes.routes.each do |route|
      static_path = []
      route.segments.each do |segment|
        if segment.kind_of?(ActionController::Routing::StaticSegment)
          static_path << segment.value if (segment.respond_to?(:value) && segment.value != "/")
        elsif segment.kind_of?(ActionController::Routing::DynamicSegment)
          static_path << :dynamic unless (segment.respond_to?(:key) && segment.key == :format)   
        end
      end
      routes << [static_path, route.conditions[:method]] unless route.conditions[:method].nil?
    end
    routes
  end

  def prepare_request_path(path)
    path = path[0..(path.rindex('.')-1)] if path.include?('.')
    path_parts = path.split("/")
    path_parts.delete("")
    path_parts
  end

  def is_help_extras_enabled?(path)
    path =~ /(.+).help\z/ ? $1 : false
  end

  def build_location_uri(env)
    host = env["REMOTE_HOST"]
    port = env["SERVER_PORT"]
    path = is_help_extras_enabled?(env["PATH_INFO"])
    "http://#{host}:#{port}/help#{path}"
  end

end