module Baurets
  module Optionsful

    class Config

      def initialize
        # Initialize default settings- May be overriden if RAILS_ROOT/config/optionsful.yml exists.
        @config = { :http => {:base_path => "/optionsful"} } 
        setup
      end

      def setup
        require "yaml"
        begin
          yaml_file = File.join(RAILS_ROOT, "config", "optionsful.yml")
          if File.exist? yaml_file
            conf = YAML::load_file(yaml_file)[RAILS_ENV].symbolize_keys
            configure(conf) if conf
          end
        rescue
        end
      end
      def configure(conf)
        @config[:http][:base_path] = conf[:http][:base_path] if (conf[:http] && conf[:http][:base_path])
      end


      def base_path
        @config[:http][:base_path]
      end
      
    end

  end
end