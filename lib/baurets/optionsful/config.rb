module Baurets
  module Optionsful
    
    class Config
      
       def initialize(options = {})
          @config = configure_options(options)
          setup
          self
        end

        def base_path
          @config[:link][:path][:base]
        end

        private

        def configure_options(options = {})
          default_opts = { :http => { :base_path => "/optionsful"},  :file => "", :environment => "development" }
          conf = {}
          if defined? RAILS_ROOT
            conf = default_opts.merge!({:file => (File.join(RAILS_ROOT, 'config', 'optionsful.yml'))})
          else
            conf = default_opts.merge!({ :http => { :base_path => "/optionsful"} })
          end
          conf = conf.merge!(options) unless options.empty?
          conf
        end

        def setup
          require "yaml"
          yaml_file = @config[:file]
          begin
            if File.exist? yaml_file
              conf = YAML::load_file(yaml_file)[@config[:environment]].symbolize_keys
              configure(conf) if conf
            end
          rescue
          end
        end

        def configure(conf)
          @config[:http][:base_path] = conf[:http]["base_path"] if (conf[:http] && conf[:http]["base_path"])
          @config[:file] = conf[:file] if conf[:file] 
          @config[:environment] = conf[:environment] if conf[:environment]
        end
      
      
    end
    
  end
end