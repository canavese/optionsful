module Baurets
  module Optionsful
    class Config

      DEFAULT = { :link => false, :host => 'auto', :base_path =>  "/api", :propagate => true }

      def initialize(file = nil, options = {})
        unless file.nil?
          @config = load_from_file(file, get_env)
        else
          begin
            if File.exist?(File.join(Rails.root, 'config', 'optionsful.yml'))
              envs = YAML::load_file(File.join(Rails.root, 'config', 'optionsful.yml')).symbolize_keys
              @config = envs[get_env].symbolize_keys
            end
          rescue => e
            # TODO Rails.logger log it
          end
        end
        @config = DEFAULT if @config.nil?
        @config.merge!(options) unless options.empty?
        @config
      end

      def get_env
        :test if Rails.env.test?
        :development if Rails.env.development?
        :production if Rails.env.production?
      end

      def load_from_file(file, environment)
        config = nil
        require 'yaml'
        if File.exist?(file)
          begin
            envs = YAML::load_file(file).symbolize_keys
            config = envs[environment].symbolize_keys
          rescue => e
            # TODO Rails.logger log it
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
