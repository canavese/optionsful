module Baurets
  module Optionsful
    module Introspections

      def self.is_part_static?(routes, index, value)
        routes.each do |route|
          return true if route[0][index] == value
        end
        return false
      end

      def self.do_routing_introspection
        returning Array.new do |routes|
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
            routes << [static_path, [route.conditions[:method].to_s.upcase, route_requirements[:action]], route_requirements] unless route.conditions[:method].nil?
          end
        end
      end

      def self.guess_route(routes, path)
        guess = []
        parts = prepare_request_path(path)
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

      def self.discover_controller_name(path)
        routes = do_routing_introspection
        guess = guess_route(routes, path)
        routes.each do |route|
          if route[0] == guess
            return route[2][:controller]
          end
        end
      end

      def self.do_the_matches(routes, route_guess)
        allow = ""
        routes.each do |route|
          if route.first == route_guess
            allow += route[1][0].to_s.upcase + "|" 
          end
        end
        allow = allow.split("|").join(", ")
      end

      def self.prepare_request_path(path)
        path_parts = []
        unless path.kind_of? Array
          path = path[0..(path.rindex('.')-1)] if path.include?('.')
          path_parts = path.split("/")
        else
          path_parts = path
        end
        path_parts.delete("")
        path_parts
      end

    end
  end
end