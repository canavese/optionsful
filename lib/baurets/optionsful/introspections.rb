module Baurets
  module Optionsful
    module Introspections

      def self.do_the_matches(path_info)
        routes = Rails.application.routes.routes if defined? Rails # Rails major = 3
        routes.reject!{ |r| r.path == "/rails/info/properties" } # skip the route if it's internal info route
        allow = ""
        routes.each do |route|
          if path_info =~ route.conditions[:path_info] 
            if route.verb
              allow += (route.verb.to_s.upcase + "|") unless allow.include?(route.verb.to_s.upcase)
            else
              # TODO - return 'ANY' doesn't sound ANY good ;p
              allow = "GET" 
            end
          end
        end
        allow = allow.split("|").join(", ") 
      end

    end
  end
end
