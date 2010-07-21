require 'rubygems'
require 'yard'

class OptionsfulDocs
  
  def initialize(app)  
    @app = app
  end  

  def call(env) 
    unless env["PATH_INFO"].index("/opts/") == 0
      @app.call(env)
    else
      extract_documentation(env)
    end
  end
  
  def extract_documentation(env)
    
    parts = env["PATH_INFO"].split("/")
    parts.delete("")
    parts.delete("opts")
    controller_name = parts.first
    methods = parts.last.split(";")
    
    controller_name = controller_name.camelize + "Controller"
    
    opts = File.new(File.join(RAILS_ROOT, "public", "opts"))
    # opts.exist? 
    
    # file_name = File.join(RAILS_ROOT, "app", "controllers", (controller_name + "_controller.rb"))
    
    yardoc = YARD::CLI::Yardoc.new
    # yardoc.files = file_name
    # puts file_name
    yardoc.options[:serializer] = YARD::Serializers::FileSystemSerializer.new({ :basepath => File.join(RAILS_ROOT, "public", "opts"), :extension => "html" })

     yardoc.run
     
     
    
   # [200, {}, "Under development!!! \n parts =  #{parts.inspect} \n controller = #{controller_name} \n methods = #{methods.inspect}" ]
    [303, {"Location" => location(env)}, ""]
  end
  
  def location(env)
    server_name = env["SERVER_NAME"]
    server_port = env["SERVER_PORT"]
    "http://#{server_name}:#{server_port}/opts"
  end

  
end