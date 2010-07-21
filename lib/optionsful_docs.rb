require 'rubygems'
require 'yard'
require 'rdoc/rdoc'
require 'fileutils'

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

    require 'rdoc/rdoc'
    docr = RDoc::RDoc.new
    files = File.join(RAILS_ROOT, "app", "controllers", "posts_controller.rb")
    
    docr.document([files])
    
    FileUtils.cp_r File.join(RAILS_ROOT, "doc"), File.join(RAILS_ROOT, "public", "api")
    

    # output_file_name = File.join(RAILS_ROOT, "doc", "classes", (controller_name.camelize + "Controller.html"))

    # str = File.new(output_file_name).


    #  opts = File.new(File.join(RAILS_ROOT, "public", "opts"))
    #     # opts.exist? 
    #     
    #     # file_name = File.join(RAILS_ROOT, "app", "controllers", (controller_name + "_controller.rb"))
    #     
    #     yardoc = YARD::CLI::Yardoc.new
    #     # yardoc.files = file_name
    #     # puts file_name
    #     yardoc.options[:serializer] = YARD::Serializers::FileSystemSerializer.new({ :basepath => File.join(RAILS_ROOT, "public", "opts"), :extension => "html" })
    # debugger
    #      yardoc.run
    #      
    #      
    [303, {"Location" => location(env)}, ""]
    #[200, {}, "Under development!!! \n  \n controller = #{controller_name} \n methods = #{methods.inspect}" ]

  end

  def location(env)
    server_name = env["SERVER_NAME"]
    server_port = env["SERVER_PORT"]
    "http://#{server_name}:#{server_port}/api/"
  end


end