module Baurets
  module Optionsful
    module Introspections

      def routing_introspection
        ObjectSpace.each_object(Rails::Application) {|x| p x } 
      end

    end
  end
end