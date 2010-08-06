module Baurets
  module Optionsful
    module Introspections

      def self.do_the_matches(path_info)
        routes = gimme_routes
        allow = ""
        allow = match_verbs_tabajara(path_info)
        if allow.empty?
          allow = do_rails_recognition(path_info)
        end
        allow
      end

      private 

      def self.do_rails_recognition(path_info)
        allow = ""
        gimme_routes.each do |route|
          if path_info =~ route.conditions[:path_info] 
            if route.verb
              allow += (route.verb.to_s.upcase + "|") unless allow.include?(route.verb.to_s.upcase)
            else
              allow = "GET" # TODO Return 'ANY' doesn't sound ANY good to me.. ;p
            end
          end
        end
        allow = allow.split("|").join(", ")
      end

      def self.match_verbs_tabajara(path_info)
        routes_paths = build_static_paths
        route_guess = guess_route(routes_paths,path_info)
        allow = ""
        routes_paths.each do |route|
          if route.first == route_guess
            allow += (route[1].to_s + "|") unless allow.include?(route[1].to_s.upcase)
          end
        end
        allow = allow.split("|").join(", ")
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

      def self.prepare_request_path(path)
        path_parts = []
        path = path[0..(path.rindex('.')-1)] if path.include?('.')
        path_parts = path.split("/")
        path_parts.delete("")
        path_parts
      end

      def self.is_part_static?(routes, index, value)
        routes.each do |route|
          return true if route[0][index] == value
        end
        return false
      end

      def self.build_static_paths
        # outputs [["paths"], "VERB"]
        routes_paths = []
        gimme_routes.each do |route|
          raw_parts = route.conditions[:path_info].inspect.split("\/")
          # TODO Check this carefully
          raw_parts.delete("")
          raw_parts.delete("\\A\\") 
          raw_parts.delete("([^\\")
          raw_parts.pop
          path_parts = []
          raw_parts.each do |part|
            if part =~ /\A(\w+)/
              path_parts << $1 
            else
              path_parts << :dynamic
            end
          end
          routes_paths << [path_parts, route.verb.to_s.upcase]
        end
        routes_paths
      end

      def self.gimme_routes
        routes = Rails.application.routes.routes
        routes.reject!{ |r| r.path == "/rails/info/properties" } # skip the route if it's internal info route
        routes
      end

    end
  end
end
