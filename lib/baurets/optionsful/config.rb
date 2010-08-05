module Baurets
  module Optionsful
    class Config

      DEFAULT = { :link => false, :host => 'auto', :base_path =>  "/api", :propagate => true }

      def initialize(file = nil, options = {})
        unless file.nil?
          @config = load_from_file(file, get_env)
        else
          begin
            if (defined? Rails && File.exist?(File.join(Rails.root, 'config', 'optionsful.yml')))
              envs = YAML::load_file(File.join(Rails.root, 'config', 'optionsful.yml')).symbolize_keys
              @config = envs[get_env].symbolize_keys
            end
          rescue
          end
        end
        @config = DEFAULT if @config.nil?
        @config
      end

      def get_env
        if defined? Rails
          env = :test if Rails.env.test?
          env = :development if Rails.env.development?
          env = :production if Rails.env.production?
        else
          env = :development
        end
        env
      end

      def load_from_file(file, environment)
        config = nil
        require 'yaml'
        if File.exist?(file)
          begin
            envs = YAML::load_file(file).symbolize_keys
            config = envs[environment].symbolize_keys
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
