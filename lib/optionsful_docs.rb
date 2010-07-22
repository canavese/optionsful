require 'rubygems'
require 'yard'
require 'rdoc/rdoc'
require 'fileutils'
require File.join(File.dirname(__FILE__), 'introspections.rb')

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
    # puts "#{parts.inspect}"
    http_methods = parts.pop.split(";")

    controller_actions = []
    http_methods.each do |verb|
      controller_actions << [verb, relate_action_to_method(parts, verb)]
    end
    
    controller_actions.delete_if {|pair| pair[1].empty? }
    puts "controller_actions: #{controller_actions.inspect}"
    controller_name = Introspections.discover_controller_name(parts) + "_controller"
    file = File.join(RAILS_ROOT, "app", "controllers", controller_name + ".rb")
    controller_class = controller_name.camelize

    service_doc = extract_comments_above(file, find_line_for(file, controller_class, :class)).join("\n")

    methods_docs = []
    controller_actions.each do |info|
      methods_docs << [info, extract_comments_above(file, find_line_for(file, info[1], :method)).join("\n")]
    end

    body = "\n\nService: \n" + service_doc + "\n" 
    methods_docs.each do |md|
      body += "\n\nMethod: #{md[0][0]} \n Action: #{md[0][1]} \n-- end ---\n"
    end

    [200, {}, "Under development!!! \n  #{body}"]
  end

  def relate_action_to_method(path, verb)
    action = ""
    routes = Introspections.do_routing_introspection
    route_guess = Introspections.guess_route(routes, path)
    routes.each do |route|
      # puts "PATH: #{path.inspect}"
      # puts "GUESS: #{route_guess.inspect}"
      # 
      puts "Route inspection: #{route.inspect}"
      # puts "Route first: #{route.first.inspect}"
      # puts "VERB: #{verb}"

      if ((route.first == route_guess) && (route[1][0] == verb))
        action = route[1][1] unless route[1][1].empty?
      end
    end
    action
  end



  def file_lines(file_name)
    lines = []
    begin
      file = File.new(file_name, "r")
      while (line = file.gets)
        line = line.strip
        lines << line unless line.empty?
      end
      file.close
    rescue => err
      puts "Exception: #{err}"
      err
    end
    lines.delete(nil)
    lines
  end  

  def extract_comments_above(file_name, line_number)
    puts "extract_comments_above(#{file_name}, #{line_number})"
    lines = file_lines(file_name)
    doc = []
    while ((line_number = line_number -1) && line_number >= 0 && !lines.nil? && !lines[line_number].empty? )#&& lines[line_number].lstrip[0] == "#")
      line = lines[line_number].lstrip
      line = line
      doc << line unless line[0] != 35 # 
    end
    doc.reverse
  end

  def find_line_for(file, name, type) 
    signature = ""
    if type == :class
      signature = "class " + name
    elsif type == :method
      signature = "def " + name
    end
    counter = 1;
    begin
      file = File.new(file, "r")
      while (line = file.gets)
        if line.include? signature
          return counter
        end
        counter += 1
      end
      file.close
    rescue => err
      err
    end
    counter
  end

  def location(env)
    server_name = env["SERVER_NAME"]
    server_port = env["SERVER_PORT"]
    "http://#{server_name}:#{server_port}/api/"
  end





end