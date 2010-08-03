module Baurets
  module Optionsful
    class Config

      DEFAULT = { :link => false, :host => 'auto', :base_path =>  "/optionsful", :propagate => true }

      def initialize(file = nil, options = {})
        unless file.nil?
          environment = "test" #TODO
          @config = load_from_file(file, environment)
        else
          @config = DEFAULT
        end
      end



      def load_from_file(file, environment)
        config = nil
        if File.exist?(file)
          require 'yaml'
          begin
            config = YAML::load_file(file)[environment].symbolize_keys
          rescue => e
            puts e.backtrace
          end
        end
        config
      end
      
      def method_missing(name, *args)
        return @config[name.to_sym] 
      end

    end
  end
end
