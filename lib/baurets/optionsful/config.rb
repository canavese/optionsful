
require 'yaml'

module Baurets
  module Optionsful
    class Config

      DEFAULT = { :link => false, :host => 'auto', :base_path =>  "/api", :propagate => true }

      def initialize(file = nil, options = {})
        if file.nil?
          file = File.join(Rails.root, 'config', 'optionsful.yml')
        end
        config = load_yaml(file, get_env)
        config = DEFAULT if config.nil? or config.empty?
        config.merge!(options) unless options.empty?
        @config = config
        config
      end

      def get_env
        :test if Rails.env.test?
        :development if Rails.env.development?
        :production if Rails.env.production?
      end

      def load_yaml(file, environment)
        config = nil
        if File.exist?(file)
          begin
            envs = YAML::load_file(file)
            raise "Could not parse the YAML." if (envs.empty? or (not envs.kind_of?(Hash)))
            envs = envs.symbolize_keys if envs
            config = envs[environment].symbolize_keys if (envs && envs[environment])
          rescue
            config = nil
          end
          config
        end

      end

    def method_missing(name, *args)
      return @config[name.to_sym] 
    end

  end
end
end
