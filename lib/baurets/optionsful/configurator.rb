require 'yaml'

module Baurets
  module Optionsful
    class Configurator

      DEFAULT = { :link => false, :host => 'auto', :base_path =>  "/api", :propagate => true }

      def configure!
        file = File.join(Rails.root, 'config', 'optionsful.yml')
        configuration = load_yaml(file, Rails.env.to_sym) if File.exist?(file)
        configuration = DEFAULT if configuration.nil?
        configuration
      end
      
      private

      def load_yaml(file, environment)
        configuration = nil
        begin
          envs = YAML::load_file(file)
          raise "Could not parse the YAML." if (envs.empty? or (not envs.kind_of?(Hash)))
          envs = envs.symbolize_keys if envs
          configuration = envs[environment].symbolize_keys if (envs && envs[environment])
        rescue
          configuration = nil
        end
        configuration
      end

    end
  end
end
